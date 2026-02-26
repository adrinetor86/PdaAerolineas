select * from V_VUELOS
select * from vuelo

select * from V_TRIPULACION_VUELOS where vuelo_id=1

exec SP_GET_TRIPULANTES_VUELO 1
select * from asignacion_tripulacion where vuelo_id=1


select * from tripulante