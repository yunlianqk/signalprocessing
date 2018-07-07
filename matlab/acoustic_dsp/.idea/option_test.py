

options = {'region1': [90, 60], 'region2': [60, 30], 'region3': [30, 0],
           'region4': [0, -30], 'region5': [-30, -60], 'region6': [-60, -90],
           'region7': [-90, -60], 'region8': [-60, -30], 'region9': [-30, 0],
           'region10': [0, 30], 'region11': [30, 60], 'region12': [60, 90]}

angle = -38

print angle in range(-60, -30)

degree25 = -38
degree36 = 90
degree47 = 28

regions = {1: range(0,30), 2:range(30,60), 3:range(60,90),
           4:range(-30,0), 5: range(-60,-30), 6:range(-90,-60)}


doa = [0,0]

if degree25 in regions[1] and degree36 in regions[3] and degree47 in regions[2]:
    doa = [0,30]
elif degree25 in regions[4] and degree36 in regions[2] and degree47 in regions[3]:
    doa = [30, 60]
elif degree25 in regions[5] and degree36 in regions[1] and degree47 in regions[3]:
    doa = [60, 90]
elif degree25 in regions[6] and degree36 in regions[4] and degree47 in regions[2]:
    doa = [90, 120]
elif degree25 in regions[6] and degree36 in regions[5] and degree47 in regions[1]:
    doa = [120, 150]
elif degree25 in regions[5] and degree36 in regions[6] and degree47 in regions[4]:
    doa = [150, 180]
elif degree25 in regions[4] and degree36 in regions[6] and degree47 in regions[5]:
    doa = [180, 210]
elif degree25 in regions[1] and degree36 in regions[5] and degree47 in regions[6]:
    doa = [210, 240]
elif degree25 in regions[2] and degree36 in regions[4] and degree47 in regions[6]:
    doa = [240, 270]
elif degree25 in regions[3] and degree36 in regions[1] and degree47 in regions[5]:
    doa = [270, 300]
elif degree25 in regions[3] and degree36 in regions[2] and degree47 in regions[4]:
    doa = [300, 330]
elif degree25 in regions[2] and degree36 in regions[3] and degree47 in regions[1]:
    doa = [330, 360]
else:
    doa = [0, 0]

print doa