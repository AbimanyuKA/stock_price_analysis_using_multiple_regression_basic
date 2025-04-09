import csv
import random
from datetime import datetime, timedelta

random.seed(42)

start_date = datetime(2022, 1, 1)
end_date = datetime(2025, 1, 1)
dates = []
current_date = start_date
while current_date < end_date:
    dates.append(current_date.strftime('%Y-%m-%d'))
    current_date += timedelta(days=30)

data = []
prev_oil_price = 70.0
prev_gold_price = 1800.0
prev_sp500 = 4000.0
prev_fii = 2000.0

for i, date in enumerate(dates):
    open_price = round(random.uniform(1500, 2000), 2)
    high_price = round(random.uniform(2000, 2500), 2)
    low_price = round(random.uniform(1400, 1500), 2)
    close_price = round(random.uniform(1500, 2000), 2)
    volume = random.randint(1_000_000, 5_000_000)
    interest_rate = round(random.uniform(5.0, 7.5), 2)
    inflation = round(random.uniform(3.0, 6.0), 2)
    gdp_growth = round(random.uniform(6.0, 8.0), 2)
    vix = round(random.uniform(10, 20), 2)
    monthly_return = round(random.uniform(-5.0, 5.0), 2)

    oil_volatility = random.uniform(-3, 3)
    oil_price = round(max(30, prev_oil_price + oil_volatility), 2)
    prev_oil_price = oil_price

    gold_volatility = random.uniform(-30, 30)
    gold_price = round(prev_gold_price + gold_volatility, 2)
    prev_gold_price = gold_price

    sp_volatility = random.uniform(-50, 50)
    sp500 = round(prev_sp500 + sp_volatility, 2)
    prev_sp500 = sp500

    fii_volatility = random.uniform(-200, 200)
    fii_flow = round(prev_fii + fii_volatility, 2)
    prev_fii = fii_flow

    data.append([
        date,
        open_price,
        high_price,
        low_price,
        close_price,
        volume,
        interest_rate,
        inflation,
        gdp_growth,
        vix,
        monthly_return,
        oil_price,
        gold_price,
        sp500,
        fii_flow
    ])

header = [
    "Date", "Open", "High", "Low", "Close", "Volume",
    "Interest_Rate", "Inflation", "GDP_Growth", "VIX", "Monthly_Return",
    "Oil_Price", "Gold_Price", "SP500", "FII_Flow"
]

with open("enhanced_stock_data.csv", mode="w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(header)
    writer.writerows(data)

print("Enhanced stock data CSV file 'enhanced_stock_data.csv' created successfully!")
print(f"Generated {len(dates)} months of data with additional external factors.")
