import pandas as pd
import matplotlib.pyplot as plt 

df_2023 = pd.read_excel("ThinkWildHotlineData-2022-2023.xlsx", sheet_name=0) ## This gives you only data form 2023
df_2022 = pd.read_excel("ThinkWildHotlineData-2022-2023.xlsx", sheet_name=1)

#Filtered to only show Mallards
Mallards2023 = df_2023[df_2023['Species'] == "MALL"]
Mallards2022 = df_2022[df_2022['Species'] == "MALL"]

Mallards2023HBC = Mallards2023[Mallards2023['Situation'] == "Hit by Car (HBC)"]
Mallards2022HBC = Mallards2022[Mallards2022['S'] == "HBC"]

#Time series analysis table
Months = 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'

hbc2023 = {}
for month in Months:
    count1 = len(Mallards2023HBC[Mallards2023HBC['Month'] == month]) #Gives you the count of incidents in the month
    hbc2023[month[:3] + "2023"] = count1

hbc2022 = {}
for month in Months:
    count2 = len(Mallards2022HBC[Mallards2022HBC['Month'] == month]) #Gives you the count of incidents in the month
    hbc2022[month[:3] + "2022"] = count2

#hbc2022
#hbc2023
hbc = {}
hbc.update(hbc2022)
hbc.update(hbc2023)

#Time Series Analysis plot
x_value = list(hbc.keys())
y_value = list(hbc.values())

plt.figure(figsize=(10, 5))

plt.plot(x_value, y_value, marker='o', linestyle='-')
plt.xticks(rotation=90)
plt.locator_params(axis="y", integer=True, tight=True) #sets y axis to only integer numbers
plt.xlabel("Months")
plt.ylabel("Reports")
plt.title("Incident Reports of Mallards Hit by Cars in 2022 & 2023")
plt.show()