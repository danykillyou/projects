import requests
from datetime import datetime
from dateutil.relativedelta import relativedelta
import json
import calendar


def dates(items):
    dates = {}
    description = {}
    for item in items:
        x = item["date"].split("-")
        year = int(x[0])
        month = int(x[1])
        day = int(x[2])
        if f"{month},{year}" in dates.keys() or f"{month},{year}" in description.keys():
            dates[f"{month},{year}"].append(day)
            description[f"{month},{year}"].append(f"\n\033[34m {day}\033[0m : {item['title']}")
        else:
            dates.update({f"{month},{year}": [day]})
            description.update({f"{month},{year}": [f"\033[34m{day}\033[0m : {item['title']}"]})
    return dates, description


def calendar_full(dates, descr):
    calendar_end = ""
    for key in dates.keys():
        month = int(key.split(",")[0])
        year = int(key.split(",")[1])
        c = calendar.TextCalendar(calendar.SUNDAY).formatmonth(year, month).replace("\n", " \n ")
        for day in dates[key]:
            c = c.replace(f" {day} ", f"\033[34m {day}\033[0m ", 1)
        calendar_end += "\n" + c + ",".join(descr[key]) + " \n"
    return calendar_end


today = datetime.today().strftime('%Y-%m-%d')
in_3_months = (datetime.today() + relativedelta(months=+3)).strftime('%Y-%m-%d')
respond = requests.get(f"https://www.hebcal.com/hebcal?v=1&cfg=json&maj=on&min=on&mod=on&year=now&month=x&start={today}&end={in_3_months}")
items = json.loads(respond.text)["items"]
dates, descr = dates(items)
calendar_end = calendar_full(dates, descr)
print(f"{calendar_end}")
