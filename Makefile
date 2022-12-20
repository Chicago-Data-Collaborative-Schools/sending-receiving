zoned_receiving.db : zoned_receiving.csv
	csvs-to-sqlite $^ $@
	sqlite-utils $@ "update zoned_receiving set ZONESCH_ID = NULL, ZONESCH_NAME = NULL where ZONESCH_ID = '--'"
	sqlite-utils transform $@ zoned_receiving --type ZONESCH_ID integer
	sqlite3 $@ < scripts/school.sql
	sqlite-utils transform $@ zoned_receiving \
            --drop ATTSCH_NAME \
            --drop ATTSCH_GRADECAT \
            --drop ATTSCH_NETWORK \
            --drop ATTSCH_GOVERNANCE \
            --drop ZONESCH_NAME \
            --drop ZONESCH_GRADECAT \
            --drop ZONESCH_GOVERNANCE \
            --drop ZONESCH_NETWORK
	sqlite-utils add-foreign-keys $@ \
            zoned_receiving ATTSCH_ID school id \
            zoned_receiving ZONESCH_ID school id
	sqlite-utils transform $@ school --pk id

zoned_receiving.csv : raw/FOIA_N012000-112122_Zoned_by_Res_HS.xlsx
	in2csv --sheet=Data $< > $@
