# Generate creation dates comboes reparis and sms exchanges
# Usage: python dategen.py

import math
import random
import datetime

repairs = [
    "(1, 1, 69, 80.00, 'Needs urgent repair', '2 hours', 'ongoing', 'accepted',",
    "(2, 2, 70, 50.00, 'Screen replacement needed', '3 hours', 'done', 'accepted',",
    "(3, 3, 71, 90.00, 'Software optimization required', '4 hours', 'done', 'accepted',",
    "(4, 4, 69, 60.00, 'Battery replacement needed', '5 hours', 'done', 'accepted',",
    "(5, 7, 69, 70.00, 'Motor replacement required', '6 hours', 'done', 'accepted',",
    "(6, 8, 71, 40.00, 'Heating element needs replacement', '7 hours', 'done', 'accepted',",
    "(7, 11, 71, 80.00, 'Leg repair needed', '8 hours', 'done', 'accepted',",
    "(8, 12, 70, 50.00, 'Upholstery replacement required', '9 hours', 'done', 'accepted',",
    "(9, 19, 69, 90.00, 'Not turning on', '7 hours', 'done', 'accepted',",
    "(10, 20, 71, 60.00, 'Blade not cutting properly', '5 hours', 'done', 'declined',",
    "(11, 23, 71, 70.00, 'Handle broken', '4 hours', 'done', 'accepted',",
    "(12, 24, 70, 40.00, 'Rust on the head', '2 hours', 'done', 'accepted',",
    "(13, 27, 70, 80.00, 'Zipper not working', '5 hours', 'ongoing', 'accepted',",
    "(14, 28, 69, 50.00, 'Sole worn out', '3 hours', 'done', 'accepted',",
    "(15, 31, 69, 90.00, 'Engine not starting', '6 hours', 'ongoing', 'accepted',",
    "(16, 32, 71, 60.00, 'Flat tire', '4 hours', 'done', 'accepted',",
    "(17, 35, 71, 70.00, 'Stopped ticking', '3 hours', 'done', 'accepted',",
    "(18, 36, 70, 40.00, 'No sound output', '9 hours', 'waiting', 'waiting',",
    "(19, 39, 70, 80.00, 'Lens not focusing', '8 hours', 'done', 'accepted',",
    "(20, 40, 69, 50.00, 'No audio in one ear', '6 hours', 'done', 'accepted',",
    "(21, 43, 69, 90.00, 'Paper jamming', '10 hours', 'done', 'accepted',",
    "(22, 44, 71, 60.00, 'Not recognized by computer', '8 hours', 'done', 'accepted',",
    "(23, 47, 71, 70.00, 'Not brewing', '5 hours', 'done', 'accepted',",
    "(24, 48, 70, 40.00, 'Fan not working', '3 hours', 'done', 'accepted',",
    "(25, 1, 70, 80.00, 'Wobbly structure', '8 hours', 'ongoing', 'accepted',",
    "(26, 2, 69, 50.00, 'Torn upholstery', '6 hours', 'abandoned', 'declined',",
    "(27, 21, 70, 80.00, 'Motor overheating', '3 hours', 'ongoing', 'accepted',",
    "(28, 22, 69, 50.00, 'Not holding charge', '9 hours', 'done', 'accepted',",
    "(29, 25, 69, 60.00, 'Measurement not accurate', '8 hours', 'done', 'accepted',",
    "(30, 26, 71, 30.00, 'Blade dull', '6 hours', 'done', 'declined',",
    "(31, 29, 71, 70.00, 'Sole separation', '9 hours', 'abandoned', 'declined',",
    "(32, 30, 70, 40.00, 'Zipper stuck', '7 hours', 'done', 'declined',",
    "(33, 33, 70, 80.00, 'Brake issues', '10 hours', 'done', 'accepted',",
    "(34, 34, 69, 50.00, 'Cracked deck', '8 hours', 'done', 'declined',",
    "(35, 37, 69, 60.00, 'Alarm not sounding', '7 hours', 'done', 'accepted',",
    "(36, 38, 71, 30.00, 'Not oscillating', '5 hours', 'done', 'accepted',",
    "(37, 41, 71, 70.00, 'Screen not responsive', '4 hours', 'waiting', 'waiting',",
    "(38, 42, 70, 40.00, 'Charging issue', '2 hours', 'done', 'declined',",
    "(39, 45, 70, 80.00, 'Ports not working', '6 hours', 'done', 'accepted',",
    "(40, 46, 69, 50.00, 'Artifacting on display', '4 hours', 'ongoing', 'accepted',",
    "(41, 49, 69, 60.00, 'Not heating', '9 hours', 'waiting', 'accepted',",
    "(42, 50, 71, 30.00, 'Heating element replacement needed', '7 hours', 'done', 'declined',",
    "(43, 3, 71, 70.00, 'Scratched surface', '4 hours', 'ongoing', 'accepted',",
    "(44, 4, 70, 40.00, 'Drawer stuck', '2 hours', 'ongoing', 'accepted',",
    "(45, 5, 69, 90.00, 'Blade not cutting straight', '7 hours', 'done', 'accepted',",
    "(46, 6, 71, 60.00, 'Chuck not gripping', '5 hours', 'done', 'accepted',",
    "(47, 9, 71, 70.00, 'Blade not retracting', '4 hours', 'ongoing', 'accepted',",
    "(48, 10, 70, 40.00, 'Jaw misalignment', '2 hours', 'ongoing', 'accepted',",
    "(49, 13, 70, 80.00, 'Torn stitching', '5 hours', 'ongoing', 'accepted',",
    "(50, 14, 69, 50.00, 'Zipper snagging', '3 hours', 'ongoing', 'accepted',",
]

sms = [
    "(1, 'The repair cost for your laptop is CHF 80.00.', '+1234567890', '7509811074', 'processed',",
    "(1, 'Your quote for the laptop repair has been accepted.', '7509811074', '+1234567890', 'processed',",
    "(2, 'The repair cost for your smartphone is CHF 50.00.', '+1234567890', '3869329401', 'processed',",
    "(2, 'Your quote for the smartphone repair has been accepted.', '3869329401', '+1234567890', 'processed',",
    "(3, 'The repair cost for your desktop computer is CHF 90.00.', '+1234567890', '9333998972', 'processed',",
    "(3, 'Your quote for the desktop computer repair has been accepted.', '9333998972', '+1234567890', 'processed',",
    "(4, 'The repair cost for your tablet is CHF 60.00.', '+1234567890', '4153821884', 'processed',",
    "(4, 'Your quote for the tablet repair has been accepted.', '4153821884', '+1234567890', 'processed',",
    "(5, 'The repair cost for your vacuum cleaner is CHF 70.00.', '+1234567890', '9289485117', 'processed',",
    "(5, 'Your quote for the vacuum cleaner repair has been accepted.', '9289485117', '+1234567890', 'processed',",
    "(6, 'The repair cost for your toaster is CHF 40.00.', '+1234567890', '3748280535', 'processed',",
    "(6, 'Your quote for the toaster repair has been accepted.', '3748280535', '+1234567890', 'processed',",
    "(7, 'The repair cost for your dining table is CHF 80.00.', '+1234567890', '1576059000', 'processed',",
    "(7, 'Your quote for the dining table repair has been accepted.', '1576059000', '+1234567890', 'processed',",
    "(8, 'The repair cost for your sofa is CHF 50.00.', '+1234567890', '2117079631', 'processed',",
    "(8, 'Your quote for the sofa repair has been accepted.', '2117079631', '+1234567890', 'processed',",
    "(9, 'The repair cost for your drill is CHF 90.00.', '+1234567890', '5841556990', 'processed',",
    "(9, 'Your quote for the drill repair has been accepted.', '5841556990', '+1234567890', 'processed',",
    "(10, 'The repair cost for your circular saw is CHF 60.00.', '+1234567890', '1554714353', 'processed',",
    "(10, 'Your quote for the circular saw repair has been declined.', '1554714353', '+1234567890', 'processed',",
    "(11, 'The repair cost for your screwdriver set is CHF 70.00.', '+1234567890', '1625688540', 'processed',",
    "(11, 'Your quote for the screwdriver set repair has been accepted.', '1625688540', '+1234567890', 'processed',",
    "(12, 'The repair cost for your wrench is CHF 40.00.', '+1234567890', '7427338531', 'processed',",
    "(12, 'Your quote for the wrench repair has been accepted.', '7427338531', '+1234567890', 'processed',",
    "(13, 'The repair cost for your leather jacket is CHF 80.00.', '+1234567890', '2656777071', 'processed',",
    "(13, 'OK', '2656777071', '+1234567890', 'processed',",
    "(14, 'The repair cost for your running shoes is CHF 50.00.', '+1234567890', '2252330197', 'processed',",
    "(14, 'I accept', '2252330197', '+1234567890', 'processed',",
    "(15, 'The repair cost for your car is CHF 90.00.', '+1234567890', '7272619255', 'processed',",
    "(15, 'OK', '7272619255', '+1234567890', 'processed',",
    "(16, 'The repair cost for your bicycle is CHF 60.00.', '+1234567890', '4961832403', 'processed',",
    "(16, 'I accept', '4961832403', '+1234567890', 'processed',",
    "(17, 'The repair cost for your watch is CHF 70.00.', '+1234567890', '1911682485', 'processed',",
    "(17, 'OK', '1911682485', '+1234567890', 'processed',",
    "(18, 'The repair cost for your Bluetooth speaker is CHF 40.00.', '+1234567890', '9425778234', 'processed',",
    "(18, 'I accept', '9425778234', '+1234567890', 'processed',",
    "(19, 'The repair cost for your digital camera is CHF 80.00.', '+1234567890', '2086601361', 'processed',",
    "(19, 'OK', '2086601361', '+1234567890', 'processed',",
    "(20, 'The repair cost for your headphones is CHF 50.00.', '+1234567890', '3043025593', 'processed',",
    "(20, 'I accept', '3043025593', '+1234567890', 'processed',",
    "(21, 'The repair cost for your laser printer is CHF 90.00.', '+1234567890', '6681245302', 'processed',",
    "(21, 'OK', '6681245302', '+1234567890', 'processed',",
    "(22, 'The repair cost for your external hard drive is CHF 60.00.', '+1234567890', '4041368171', 'processed',",
    "(22, 'I accept', '4041368171', '+1234567890', 'processed',",
    "(23, 'The repair cost for your coffee maker is CHF 70.00.', '+1234567890', '4582711234', 'processed',",
    "(23, 'I accept', '4582711234', '+1234567890', 'processed',",
    "(24, 'The repair cost for your blender is CHF 40.00.', '+1234567890', '7214950616', 'processed',",
    "(24, 'OK', '7214950616', '+1234567890', 'processed',",
    "(25, 'The repair cost for your bookshelf is CHF 80.00.', '+1234567890', '9393204438', 'processed',",
    "(25, 'I accept', '9393204438', '+1234567890', 'processed',",
    "(26, 'The repair cost for your office chair is CHF 50.00.', '+1234567890', '7788397622', 'processed',",
    "(26, 'OK', '7788397622', '+1234567890', 'processed',",
    "(27, 'The repair cost for your angle grinder is CHF 80.00.', '+1234567890', '8183530508', 'processed',",
    "(27, 'I accept', '8183530508', '+1234567890', 'processed',",
    "(28, 'The repair cost for your electric screwdriver is CHF 50.00.', '+1234567890', '3357891471', 'processed',",
    "(28, 'OK', '3357891471', '+1234567890', 'processed',",
    "(29, 'The repair cost for your tape measure is CHF 60.00.', '+1234567890', '8046789823', 'processed',",
    "(29, 'I accept', '8046789823', '+1234567890', 'processed',",
    "(30, 'The repair cost for your hacksaw is CHF 30.00.', '+1234567890', '7644258879', 'processed',",
    "(30, 'OK', '7644258879', '+1234567890', 'processed',",
    "(31, 'The repair cost for your leather boots is CHF 70.00.', '+1234567890', '1086694457', 'processed',",
    "(31, 'I accept', '1086694457', '+1234567890', 'processed',",
    "(32, 'The repair cost for your winter jacket is CHF 40.00.', '+1234567890', '2356940339', 'processed',",
    "(32, 'OK', '2356940339', '+1234567890', 'processed',",
    "(33, 'The repair cost for your motorcycle is CHF 80.00.', '+1234567890', '9845978906', 'processed',",
    "(33, 'I accept', '9845978906', '+1234567890', 'processed',",
    "(34, 'The repair cost for your skateboard is CHF 50.00.', '+1234567890', '9631312077', 'processed',",
    "(34, 'OK', '9631312077', '+1234567890', 'processed',",
    "(35, 'The repair cost for your alarm clock is CHF 60.00.', '+1234567890', '2507780331', 'processed',",
    "(35, 'I accept', '2507780331', '+1234567890', 'processed',",
    "(36, 'The repair cost for your portable fan is CHF 30.00.', '+1234567890', '7841546275', 'processed',",
    "(36, 'OK', '7841546275', '+1234567890', 'processed',",
    "(37, 'The repair cost for your smartwatch is CHF 70.00.', '+1234567890', '6823527703', 'processed',",
    "(37, 'I accept', '6823527703', '+1234567890', 'processed',",
    "(38, 'The repair cost for your Bluetooth earbuds is CHF 40.00.', '+1234567890', '6789735999', 'processed',",
    "(38, 'OK', '6789735999', '+1234567890', 'processed',",
    "(39, 'The repair cost for your laptop docking station is CHF 80.00.', '+1234567890', '1849079988', 'processed',",
    "(39, 'I accept', '1849079988', '+1234567890', 'processed',",
    "(40, 'The repair cost for your graphics card is CHF 50.00.', '+1234567890', '3624483477', 'processed',",
    "(40, 'OK', '3624483477', '+1234567890', 'processed',",
    "(41, 'The repair cost for your microwave is CHF 60.00.', '+1234567890', '4948737986', 'processed',",
    "(41, 'I accept', '4948737986', '+1234567890', 'processed',",
    "(42, 'The repair cost for your air purifier is CHF 30.00.', '+1234567890', '5172331839', 'processed',",
    "(42, 'OK', '5172331839', '+1234567890', 'processed',",
    "(43, 'The repair cost for your coffee table is CHF 70.00.', '+1234567890', '6869372742', 'processed',",
    "(43, 'I accept', '6869372742', '+1234567890', 'processed',",
    "(44, 'The repair cost for your office desk is CHF 40.00.', '+1234567890', '8949495741', 'processed',",
    "(44, 'OK', '8949495741', '+1234567890', 'processed',",
    "(45, 'The repair cost for your jigsaw is CHF 90.00.', '+1234567890', '7927615330', 'processed',",
    "(45, 'I accept', '7927615330', '+1234567890', 'processed',",
    "(46, 'The repair cost for your impact driver is CHF 60.00.', '+1234567890', '1673941666', 'processed',",
    "(46, 'OK', '1673941666', '+1234567890', 'processed',",
    "(47, 'The repair cost for your utility knife is CHF 70.00.', '+1234567890', '9342736859', 'processed',",
    "(47, 'I accept', '9342736859', '+1234567890', 'processed',",
    "(48, 'The repair cost for your adjustable wrench is CHF 40.00.', '+1234567890', '3444095541', 'processed',",
    "(48, 'OK', '3444095541', '+1234567890', 'processed',",
    "(49, 'The repair cost for your winter gloves is CHF 80.00.', '+1234567890', '4406289262', 'processed',",
    "(49, 'I accept', '4406289262', '+1234567890', 'processed',",
    "(50, 'The repair cost for your hiking backpack is CHF 50.00.', '+1234567890', '9898594506', 'processed',",
    "(50, 'OK', '9898594506', '+1234567890', 'processed',",
]


created = []
sent = []
responded = []
modified = []
sold = []


def main():
    last_date = datetime.datetime(2022, 1, 1, 0, 8, 0)
    for i in range(50):
        date = last_date
        created.append(date)
        date += datetime.timedelta(hours=random.randint(0, 42))
        sent.append(date)
        date += datetime.timedelta(hours=random.randint(0, 42))
        responded.append(date)
        date += datetime.timedelta(hours=random.randint(0, 42))
        modified.append(date)
        date += datetime.timedelta(hours=random.randint(0, 42))
        sold.append(date)
        last_date += datetime.timedelta(hours=random.randint(0, 120))

    # Join repairs with creation and modification dates
    for i in range(len(repairs)):
        print(f"{repairs[i]} '{created[i]}', '{modified[i]}'),")

    print("\n\n\n")
    # Join SMS with creation and modification dates
    for i in range(len(sms)):
        if i % 2 == 0:
            print(f"{sms[i]} '{sent[math.floor(i/2)]}'),")
        else:
            print(f"{sms[i]} '{responded[math.floor(i/2)]}'),")

if __name__ == '__main__':
    main()
