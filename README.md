# Stock Price Analysis Using Multiple Linear Regression

## Overview
This project analyzes stock price movements and predicts future trends using multiple linear regression. The dataset includes synthetic stock data and external economic factors, and the analysis is implemented in Python and R.

---

## Project Files
- **`src/create_sample_stock_data.py`**  
  Python script to generate synthetic stock data with external factors like Interest Rate, Inflation, GDP Growth, Oil Price, Gold Price, S&P 500 Index, and FII Flows.

- **`data/enhanced_stock_data.csv`**  
  Generated CSV file containing the synthetic dataset for analysis.

- **`src/stock_price_analysis_multiple_regression.R`**  
  R script for performing manual multiple regression analysis, generating predictions, and creating visualizations.

- **`docs/Stock prediction using multi-regression.pdf`**  
  Project report detailing the methodology, results, insights, and conclusions.

- **Images**:
  - `results/3dscatterplot_stockanalysis.png`: 3D scatterplot showing relationships between predictors and stock prices.
  - `results/graph_stockanalysis.png`: Time-series plot comparing actual vs predicted prices and future projections.

---

## Methodology
### Dataset Generation
- Synthetic data generated using Python with realistic trends for stock prices and external factors.

### Regression Analysis
- Manual implementation of multiple linear regression in R using the formula:  
  $$ \beta = (X'X)^{-1}X'Y $$
- Residuals ($$ e $$) were calculated as:  
  $$ e = Y - \hat{Y} $$
- Future predictions were generated with added volatility based on historical residuals.

### Visualization
- Scatterplot showing relationships between predictors (e.g., GDP Growth and Oil Price) and stock prices.
- Time-series plot comparing actual historical prices, predicted values, and future projections.

---

## How to Run
### Python Script
1. Run `create_sample_stock_data.py` to generate the dataset (`enhanced_stock_data.csv`).
2. Ensure Python 3.x is installed along with required libraries (`csv`, `random`, etc.).

### R Script
1. Load the dataset (`enhanced_stock_data.csv`) into RStudio.
2. Execute `stock_price_analysis_multiple_regression.R` to perform regression analysis and generate visualizations.

---

## Results
- The regression model explained **89% of the variance in stock prices** ($$ R^2 = 0.89 $$).
- Key factors influencing stock prices include **GDP Growth**, **Oil Price**, and **S&P 500 Index values**.
- Future predictions for 2025 incorporate realistic volatility based on historical residuals.

---
