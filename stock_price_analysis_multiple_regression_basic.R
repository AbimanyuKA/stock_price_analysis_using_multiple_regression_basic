# Step 1: Import enhanced data
stock_data <- read.csv("enhanced_stock_data.csv")
stock_data$Date <- as.Date(stock_data$Date)

# Step 2: Manual multiple regression calculation
# Create matrix X (predictors) with all factors
X <- as.matrix(cbind(1, stock_data[, c("Interest_Rate", "Inflation", "GDP_Growth", 
                                       "VIX", "Oil_Price", "Gold_Price", 
                                       "SP500", "FII_Flow")]))
Y <- as.matrix(stock_data$Close)

# Calculate coefficients using normal equations: β = (X'X)^-1 X'Y
X_transpose <- t(X)               # Transpose of X
XTX <- X_transpose %*% X          # X'X
XTY <- X_transpose %*% Y          # X'Y
beta <- solve(XTX) %*% XTY        # Solve for β

# Calculate predictions and residuals
Y_hat <- X %*% beta
residuals <- Y - Y_hat

# Calculate R-squared
SS_total <- sum((Y - mean(Y))^2)
SS_residual <- sum(residuals^2)
R_squared <- 1 - (SS_residual / SS_total)

# Step 3: Generate future data for one year (12 months)
last_date <- max(stock_data$Date)
future_dates <- seq.Date(from = last_date + 30, by = "month", length.out = 12)

# Use trends from last 6 months to project future values
last_6 <- tail(stock_data, 6)
avg_growth_rate <- function(x) {
  mean(diff(x) / head(x, -1))
}

# Project future values for each predictor
interest_rate_future <- rep(mean(last_6$Interest_Rate), 12)
inflation_future <- rep(mean(last_6$Inflation), 12)
gdp_growth_future <- rep(mean(last_6$GDP_Growth), 12)
vix_future <- rep(mean(last_6$VIX), 12)
oil_future <- tail(last_6$Oil_Price, 1) * cumprod(rep(1 + avg_growth_rate(last_6$Oil_Price), 12))
gold_future <- tail(last_6$Gold_Price, 1) * cumprod(rep(1 + avg_growth_rate(last_6$Gold_Price), 12))
sp500_future <- tail(last_6$SP500, 1) * cumprod(rep(1 + avg_growth_rate(last_6$SP500), 12))
fii_future <- tail(last_6$FII_Flow, 1) * cumprod(rep(1 + avg_growth_rate(last_6$FII_Flow), 12))

# Create future predictor matrix
X_future <- cbind(1, interest_rate_future, inflation_future, gdp_growth_future, 
                  vix_future, oil_future, gold_future, sp500_future, fii_future)

# Predict future values
Y_future <- X_future %*% beta

# Add realistic volatility to future predictions
historical_volatility <- sd(residuals)/mean(Y)
set.seed(123) # For reproducibility
volatility_factor <- rnorm(length(Y_future), mean=1, sd=historical_volatility*0.8)
Y_fwv <- Y_future * volatility_factor


# Step 4: Create visualizations
# Create 3D scatterplot with two key predictors (GDP_Growth and Oil_Price)
library(scatterplot3d)

# Correct way to create 3D plot and add regression plane
s3d <- scatterplot3d(
  x = stock_data$GDP_Growth,
  y = stock_data$Oil_Price, 
  z = stock_data$Close,
  main = "3D Scatterplot: GDP Growth vs Oil Price vs Close",
  xlab = "GDP Growth (%)",
  ylab = "Oil Price (USD)",
  zlab = "Close Price",
  pch = 16,
  color = "blue",
  type = "h"
)

# Add regression plane correctly
mini_model <- lm(Close ~ GDP_Growth + Oil_Price, data = stock_data)
s3d$plane3d(mini_model, col = "red", lwd = 1)

# Create time series plot with actual, predicted, and future values
# Combine data for plotting
all_dates <- c(stock_data$Date, future_dates)
actual_values <- c(stock_data$Close, rep(NA, 12))
predicted_values <- c(Y_hat, Y_fwv)

# Set up plot area
plot(all_dates, actual_values, 
     type = "n",  # Set up plot without points
     ylim = range(c(actual_values, predicted_values), na.rm = TRUE),
     main = "Stock Price: Actual vs Predicted with Future Projection",
     xlab = "Date", 
     ylab = "Close Price",
     xaxt = "n")  # Suppress default x-axis

# Add nicer x-axis with 6-month intervals
date_seq <- seq.Date(from = min(all_dates), to = max(all_dates), by = "6 months")
axis(1, at = date_seq, labels = format(date_seq, "%b %Y"), las = 2)

# Add actual values
lines(stock_data$Date, stock_data$Close, col = "black", lwd = 2)
points(stock_data$Date, stock_data$Close, col = "black", pch = 16, cex = 0.7)

# Add predicted values (historical period)
lines(stock_data$Date, Y_hat, col = "blue", lwd = 2, lty = 2)

# Add future predictions with different color
lines(future_dates, Y_fwv, col = "red", lwd = 2, lty = 3)

# Add vertical line separating historical and future data
abline(v = last_date, col = "gray", lty = 2)
text(last_date, min(c(actual_values, predicted_values), na.rm = TRUE), 
     "Today", pos = 4, col = "gray")

# Add legend
legend("topleft", 
       legend = c("Actual", "Predicted (Historical)", "Predicted (Future)"),
       col = c("black", "blue", "red"), 
       lty = c(1, 2, 3),
       lwd = 2,
       bg = "white")

# Display regression equation and R-squared
cat("\nMultiple Regression Equation:\n")
cat("Close =", round(beta[1], 4))
factor_names <- c("Interest_Rate", "Inflation", "GDP_Growth", "VIX", 
                  "Oil_Price", "Gold_Price", "SP500", "FII_Flow")
for (i in 1:length(factor_names)) {
  sign <- ifelse(beta[i+1] >= 0, "+", "")
  cat(" ", sign, round(beta[i+1], 4), "*", factor_names[i])
}
cat("\n\nR-squared:", round(R_squared, 4), "\n")

