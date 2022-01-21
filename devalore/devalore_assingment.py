import os
import requests

url = "http://api.exchangeratesapi.io"
url_path = "v1/latest"
variables = "access_key=915b3944882bcb21e414d996827e47e8"


def extract_data(data_dict):
    currencies = []
    for key, val in data_dict.items():
        if val < 10:
            currencies.append(key)
    return currencies


def extract_data2(data_dict):
    currencies = []
    for key, val in data_dict.items():
        if val > 10:
            currencies.append(key)
    return currencies


def currencies_api(myfunc):
    res = requests.get(f"{url}/{url_path}?{variables}")
    res_rates = res.json()["rates"]
    m = globals()[myfunc](res_rates)
    print(m)
    return m
    return extract_data(res_rates)

    
def mock_data(res,mydata,myfunc):
    res_rates = res[mydata]
    m = globals()[myfunc](res_rates)
    print(m)
    return m
    return extract_data(res_rates)


if __name__ == "__main__":
    # print(os.environ.get("ENV"))
    # if os.environ.get("ENV") == "prod":
        print(currencies_api(myfunc="extract_data2"))
    # else:
    #     print(mock_data(myfunc="extract_data ",mydata="rates", res={'success': True, 'timestamp': 1638176644, 'base': 'EUR', 'date': '2021-11-29', 'rates': {'AED': 4.143971, 'AFN': 106.496299, 'ALL': 121.136027, 'AMD': 544.932311, 'ANG': 2.03233, 'AOA': 660.026428, 'ARS': 113.681101, 'AUD': 1.578789, 'AWG': 2.031132, 'AZN': 1.920792, 'BAM': 1.955587, 'BBD': 2.276817, 'BDT': 96.746683, 'BGN': 1.960125, 'BHD': 0.42542, 'BIF': 2245.991058, 'BMD': 1.12825, 'BND': 1.545001, 'BOB': 7.786433, 'BRL': 6.329598, 'BSD': 1.127655, 'BTC': 1.9686711e-05, 'BTN': 84.44931, 'BWP': 13.336966, 'BYN': 2.887341, 'BYR': 22113.697122, 'BZD': 2.273018, 'CAD': 1.438711, 'CDF': 2263.269695, 'CHF': 1.043394, 'CLF': 0.034022, 'CLP': 938.760075, 'CNY': 7.199474, 'COP': 4520.897162, 'CRC': 721.310812, 'CUC': 1.12825, 'CUP': 29.898621, 'CVE': 110.251305, 'CZK': 25.686841, 'DJF': 200.746843, 'DKK': 7.437457, 'DOP': 63.779512, 'DZD': 156.983639, 'EGP': 17.724016, 'ERN': 16.924098, 'ETB': 54.347827, 'EUR': 1, 'FJD': 2.399115, 'FKP': 0.841036, 'GBP': 0.845437, 'GEL': 3.4919, 'GGP': 0.841036, 'GHS': 6.92094, 'GIP': 0.841036, 'GMD': 59.148534, 'GNF': 10734.619015, 'GTQ': 8.725716, 'GYD': 235.920695, 'HKD': 8.800112, 'HNL': 27.187261, 'HRK': 7.523197, 'HTG': 111.414667, 'HUF': 368.757302, 'IDR': 16168.271696, 'ILS': 3.562227, 'IMP': 0.841036, 'INR': 84.704151, 'IQD': 1644.115774, 'IRR': 47696.762568, 'ISK': 147.044995, 'JEP': 0.841036, 'JMD': 175.603965, 'JOD': 0.799954, 'JPY': 127.791248, 'KES': 126.927091, 'KGS': 95.647042, 'KHR': 4587.169214, 'KMF': 491.917302, 'KPW': 1015.425263, 'KRW': 1346.046984, 'KWD': 0.341453, 'KYD': 0.939683, 'KZT': 491.938893, 'LAK': 12218.082317, 'LBP': 1705.188188, 'LKR': 228.349135, 'LRD': 160.493254, 'LSL': 18.345446, 'LTL': 3.331428, 'LVL': 0.682467, 'LYD': 5.204607, 'MAD': 10.427105, 'MDL': 20.038311, 'MGA': 4499.281238, 'MKD': 61.703589, 'MMK': 2019.357161, 'MNT': 3224.784729, 'MOP': 9.057575, 'MRO': 402.785004, 'MUR': 48.480774, 'MVR': 17.431621, 'MWK': 920.605486, 'MXN': 24.648992, 'MYR': 4.780959, 'MZN': 72.016561, 'NAD': 18.345108, 'NGN': 464.038334, 'NIO': 39.726889, 'NOK': 10.240526, 'NPR': 135.118019, 'NZD': 1.651086, 'OMR': 0.434354, 'PAB': 1.12766, 'PEN': 4.551335, 'PGK': 3.959391, 'PHP': 56.818098, 'PKR': 199.196708, 'PLN': 4.704294, 'PYG': 7696.975691, 'QAR': 4.107993, 'RON': 4.950086, 'RSD': 117.59775, 'RUB': 84.68, 'RWF': 1167.744597, 'SAR': 4.232659, 'SBD': 9.098842, 'SCR': 15.708922, 'SDG': 494.17314, 'SEK': 10.309011, 'SGD': 1.543893, 'SHP': 1.554053, 'SLL': 12548.394562, 'SOS': 658.897712, 'SRD': 24.27978, 'STD': 23352.494034, 'SVC': 9.866774, 'SYP': 1417.965865, 'SZL': 18.280467, 'THB': 38.098734, 'TJS': 12.725519, 'TMT': 3.960157, 'TND': 3.251604, 'TOP': 2.575679, 'TRY': 14.221533, 'TTD': 7.64595, 'TWD': 31.354403, 'TZS': 2597.230774, 'UAH': 30.550699, 'UGX': 4017.800924, 'USD': 1.12825, 'UYU': 49.744766, 'UZS': 12152.730435, 'VEF': 241253916959.76477, 'VND': 25605.630418, 'VUV': 125.596333, 'WST': 2.892428, 'XAF': 655.869717, 'XAG': 0.048269, 'XAU': 0.000627, 'XCD': 3.049152, 'XDR': 0.808989, 'XOF': 655.872623, 'XPF': 119.538087, 'YER': 282.344925, 'ZAR': 18.206511, 'ZMK': 10155.602346, 'ZMW': 20.04401, 'ZWL': 363.295992}}))
