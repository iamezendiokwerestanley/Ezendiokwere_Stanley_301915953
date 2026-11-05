# Portfolio 1 — Database Design and Modelling

I organised the data into station, rider, fare_product, ticket, validation_event. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| station | 1 |
| rider | 1 |
| fare_product | 1 |
| ticket | 1 |
| validation_event | 1 |

The 40 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Ezendiokwere_Stanley_301915953_P1_Design.md)
- [ER diagram](Ezendiokwere_Stanley_301915953_P1_ERDiagram.md)
- [Normalisation](Ezendiokwere_Stanley_301915953_P1_Normalisation.md)
- [Schema](Ezendiokwere_Stanley_301915953_P1_Schema.sql)
- [Sample data](Ezendiokwere_Stanley_301915953_P1_SampleData.sql)
- [Constraint tests](Ezendiokwere_Stanley_301915953_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Ezendiokwere_Stanley_301915953_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

