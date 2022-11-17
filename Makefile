zoned_receiving.db : zoned_receiving.csv
	csvs-to-sqlite $^ $@
	sqlite3 $@ < scripts/school.sql
	sqlite-utils transform $@ zoned_receiving \
            --drop ATTSCH_NAME \
            --drop ATTSCH_GRADECAT \
            --drop ATTSCH_NETWORK \
            --drop ATTSCH_GOVERNANCE \
            --drop ZONESCH_NM \
            --drop ZONESCH_GRADECAT \
            --drop ZONESCH_GOVERNANCE \
            --drop ZONESCH_NETWORK
	sqlite-utils add-foreign-keys $@ \
            zoned_receiving ATTSCH_ID school id \
            zoned_receiving ZONESCH_ID school id
	sqlite-utils transform $@ school --pk id

zoned_receiving.csv : raw/FOIA_N009685-061021-__ZonedByResHS.xlsx
	in2csv --sheet=Data $< > $@
