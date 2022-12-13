import requests

url = "https://de.openlegaldata.io/api/courts/"

def load_legal_data():
    response = requests.get(url)
    data = response.json()
    results = data["results"][2]["id"]

    print(results)
    return response.json()

#just for testing
load_legal_data()
