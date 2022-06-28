import json

with open('all_customer.json', 'r') as f:
    all_customers = json.load(f)

# for customer in all_customers:
#     print(customer['attributes']['name'])

with open('expired_customer.txt', 'r') as e:
    expired_customers = e.readlines()

for expired_customer in expired_customers:
    # print(expired_customer)
    for customer in all_customers:
        if customer['attributes']['name'] in expired_customer:
            print('{0}'.format(customer['attributes']['uuid']))