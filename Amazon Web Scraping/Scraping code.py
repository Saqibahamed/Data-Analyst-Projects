from bs4 import BeautifulSoup
import pandas as pd
import requests

# connecting to amazon site
url = "https://www.amazon.in/s?k=hp+laptops&crid=1FWQE051LJTB0&sprefix=hp+laptop%2Caps%2C230&ref=nb_sb_noss_2"
page = requests.get(url)
page

# extracting from the amazon website

title = soup.find_all("span",attrs={"class":"a-size-medium a-color-base a-text-normal"})
title

# stripping and collecting just the product titles

t = [i.text.strip() for i in title]
print(t)

# extracting the price of each model
price = soup.find_all("span",attrs = {"class":"a-price-whole"})
price

# extracting the rating of each model

rating = soup.find_all("a",attrs = {"class":"a-popover-trigger a-declarative"})
r = [i.text.strip() for i in rating]
r

# creating a dataframe 

df = pd.DataFrame(columns = ["Product Name","Price","Rating"])

# adding product, price and rating into the data frame
df["Product Name"] = t
df["Price"] = p
df["Rating"] = r

df

# saving it to a CSV file
df.to_csv(r"C:\Users\sharief\Documents\Saqib\data analyst\Python\HP laptops.csv")


