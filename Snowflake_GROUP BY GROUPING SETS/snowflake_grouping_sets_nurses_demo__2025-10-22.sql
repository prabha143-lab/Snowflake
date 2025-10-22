CREATE or replace TABLE nurses (
  ID INTEGER,
  full_name VARCHAR,
  medical_license VARCHAR,   -- LVN, RN, etc.
  radio_license VARCHAR      -- Technician, General, Amateur Extra
  );

INSERT INTO nurses
    (ID, full_name, medical_license, radio_license)
  VALUES
    (201, 'Thomas Leonard Vicente', 'LVN', 'Technician'),
    (202, 'Tamara Lolita VanZant', 'LVN', 'Technician'),
    (341, 'Georgeann Linda Vente', 'LVN', 'General'),
    (471, 'Andrea Renee Nouveau', 'RN', 'Amateur Extra');

SELECT COUNT(*), medical_license, radio_license
  FROM nurses
  GROUP BY GROUPING SETS (medical_license, radio_license);

COUNT(*)	MEDICAL_LICENSE	RADIO_LICENSE
3	        LVN	            null
1	        RN	            null
1	        null	        General
1	        null	        Amateur Extra
2		    Technician      null

  INSERT INTO nurses
    (ID, full_name, medical_license, radio_license)
  VALUES
    (101, 'Lily Vine', 'LVN', NULL),
    (102, 'Larry Vancouver', 'LVN', NULL),
    (172, 'Rhonda Nova', 'RN', NULL)
    ;

SELECT COUNT(*), medical_license, radio_license
  FROM nurses
  GROUP BY GROUPING SETS (medical_license, radio_license);

COUNT(*)	MEDICAL_LICENSE	RADIO_LICENSE
5	LVN	
2	RN	
1		General
1		Amateur Extra
2		Technician
3		