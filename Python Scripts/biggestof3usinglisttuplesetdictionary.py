TUPLE=(11,2,3)
A,B,C=TUPLE

LIST=[11,2,3]
D,E,F=LIST

SET={11,2,3}
G,H,I=SET

DICT = {'X': 11, 'Y': 2, 'Z': 3}
A = DICT['X']
B = DICT['Y']
C = DICT['Z']

print("Dictionary values:", A, B, C)

if A>B and A>C:
    print("A IS BIG", A)
elif B>C:
    print("B IS BIG",B)
else:
    print("C IS BIG",C)
    
if D>E and D>F:
    print("D IS BIG", D)
elif E>F:
    print("E IS BIG",E)
else:
    print("F IS BIG",F)


if G>H and G>I:
    print("G IS BIG", G)
elif H>I:
    print("H IS BIG",H)
else:
    print("I IS BIG",I)

if A > B and A > C:
    print("A (X) IS BIG", A)
elif B > C:
    print("B (Y) IS BIG", B)
else:
    print("C (Z) IS BIG", C)