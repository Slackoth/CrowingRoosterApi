/* 
triggers para la superclase usuario 
/*
Este trigger impide que todo insert o update directo en la superclase usuario no haya sido insertado previamente en alguna de las subclases.
*/
create or replace function comprueba_usuario_subclase() returns trigger as $$
DECLARE
    prueba_repartidor RECORD;
    prueba_comprador RECORD;
    prueba_vendedor RECORD;
BEGIN
    select into prueba_repartidor * from REPARTIDOR where codigo=new.id;
    select into prueba_comprador * from COMPRADOR where codigo=new.id;
    select into prueba_vendedor * from VENDEDOR where codigo=new.id;
    if (prueba_repartidor.codigo is null and prueba_comprador.codigo is null and prueba_vendedor.codigo is null)
        then
            raise exception 'El usuario % no está introducido en ninguna subclase', new.id;
    else
        return new;
    end if;
END;
$$ LANGUAGE plpgsql;

create trigger usuario_en_subclase before insert or update on USUARIO for each row execute procedure comprueba_usuario_subclase();

/*
Éste trigger elimina automaticamente de la superclase si se elimina el usuario de una subclase
*/
create or replace function borrar_usuario_superclase() returns trigger as $$
BEGIN
	if TG_TABLE_NAME = 'COMPRADOR' then
		delete from USUARIO where id=old.codigo;
		raise notice 'Al borrar a % de % lo hemos borrado como usuario',old.codigo,TG_TABLE_NAME;
		return old;
	elseif TG_TABLE_NAME = 'VENDEDOR' then
		delete from USUARIO where id=old.codigo;
		raise notice 'Al borrar a % de % lo hemos borrado como usuario',old.codigo,TG_TABLE_NAME;
		return old;
	else
		delete from USUARIO where id=old.codigo;
		raise notice 'Al borrar a % de % lo hemos borrado como usuario',old.codigo,TG_TABLE_NAME;
		return old;
	end if;
END;
$$ LANGUAGE plpgsql;

create trigger borrar_usuario_comprador after delete on COMPRADOR for each row execute procedure borrar_usuario_superclase();
create trigger borrar_usuario_vendedor after delete on VENDEDOR for each row execute procedure borrar_usuario_superclase();
create trigger borrar_usuario_repartidor after delete on REPARTIDOR for each row execute procedure borrar_usuario_superclase();

/*
Éste trigger evita que exista el mismo objeto en más de una subclase
*/
create or replace function usuario_ya_esta_en_otra_subclase() returns trigger as $$
DECLARE
	prueba_comprador RECORD;
	prueba_vendedor RECORD;
	prueba_repartidor RECORD;
BEGIN
	if TG_TABLE_NAME = 'Comprador' then
		select into prueba_vendedor * from VENDEDOR where codigo=new.codigo;
		if (prueba_vendedor.codigo is not null) then
			raise exception 'El usuario % ya pertenece a la subclase vendedor',new.codigo;
		end if;
		select into prueba_repartidor * from REPARTIDOR where codigo=new.codigo;
		if (prueba_repartidor.codigo is not null) then
			raise exception 'El usuario % ya pertenece a la subclase repartidor',new.codigo;
		end if;
	elseif TG_TABLE_NAME = 'Vendedor' then
		select into prueba_comprador * from COMPRADOR where codigo=new.codigo;
		if (prueba_comprador.codigo is not null) then
			raise exception 'El usuario % ya pertenece a la subclase comprador',new.codigo;
		end if;
		select into prueba_repartidor * from REPARTIDOR where codigo=new.codigo;
		if (prueba_repartidor.codigo is not null) then
			raise exception 'El usuario % ya pertenece a la subclase repartidor',new.codigo;
		end if;
	else
		select into prueba_comprador * from COMPRADOR where codigo=new.codigo;
		if (prueba_comprador.codigo is not null) then
			raise exception 'El usuario % ya pertenece a la subclase comprador',new.codigo;
		end if;
		select into prueba_vendedor * from VENDEDOR where codigo=new.codigo;
		if (prueba_vendedor.codigo is not null) then
			raise exception 'El usuario % ya pertenece a la subclase vendedor',new.codigo;
		end if;
	end if;
	return new;
END;
$$ LANGUAGE plpgsql;

create trigger usuario_comprador_repetido before insert or update on COMPRADOR for each row execute procedure usuario_ya_esta_en_otra_subclase();
create trigger usuario_vendedor_repetido before insert or update on VENDEDOR for each row execute procedure usuario_ya_esta_en_otra_subclase();
create trigger usuario_repartidor_repetido before insert or update on REPARTIDOR for each row execute procedure usuario_ya_esta_en_otra_subclase();

/* 
triggers para la superclase orden
/*
/*
Este trigger impide que todo insert o update directo en la superclase orden no haya sido insertado previamente en alguna de las subclases.
*/
create or replace function comprueba_orden_subclase() returns trigger as $$
DECLARE
    prueba_orden_exitosa RECORD;
    prueba_orden_cancelada RECORD;
    prueba_orden_pendiente RECORD;
BEGIN
    select into prueba_orden_exitosa * from ORDEN_EXITOSA where id_Oexitosa=new.codigo_orden;
    select into prueba_orden_cancelada * from ORDEN_CANCELADA where id_Ocancelada=new.codigo_orden;
    select into prueba_orden_pendiente * from ORDEN_PENDIENTE where id_Opendiente=new.codigo_orden;
    if (prueba_orden_exitosa.id_Oexitosa is null and prueba_orden_cancelada.id_Ocancelada is null and prueba_orden_pendiente.id_Opendiente is null)
        then
            raise exception 'La orden % no está introducida en ninguna subclase', new.codigo_orden;
    else
        return new;
    end if;
END;
$$ LANGUAGE plpgsql;

create trigger orden_en_subclase before insert or update on ORDEN for each row execute procedure comprueba_orden_subclase();

/*
Éste trigger elimina automaticamente de la superclase si se elimina una orden de una subclase
*/
create or replace function borrar_orden_superclase() returns trigger as $$
BEGIN
	if TG_TABLE_NAME = 'ORDEN_EXITOSA' then
		delete from ORDEN where codigo_orden=old.id_Oexitosa;
		raise notice 'Al borrar la orden: % de % la hemos borrado de orden',old.id_Oexitosa,TG_TABLE_NAME;
		return old;
	elseif TG_TABLE_NAME = 'ORDEN_CANCELADA' then
		delete from ORDEN where codigo_orden=old.id_Ocancelada;
		raise notice 'Al borrar la orden: % de % la hemos borrado de orden',old.id_Ocancelada,TG_TABLE_NAME;
		return old;
	else
		delete from ORDEN where codigo_orden=old.id_Opendiente;
		raise notice 'Al borrar la orden: % de % la hemos borrado de orden',old.id_Opendiente,TG_TABLE_NAME;
		return old;
	end if;
END;
$$ LANGUAGE plpgsql;

create trigger borrar_orden_exitosa after delete on ORDEN_EXITOSA for each row execute procedure borrar_orden_superclase();
create trigger borrar_orden_cancelada after delete on ORDEN_CANCELADA for each row execute procedure borrar_orden_superclase();
create trigger borrar_orden_pendiente after delete on ORDEN_PENDIENTE for each row execute procedure borrar_orden_superclase();

/*
Éste trigger evita que exista el mismo objeto en más de una subclase
*/
create or replace function orden_ya_esta_en_otra_subclase() returns trigger as $$
DECLARE
    prueba_orden_exitosa RECORD;
    prueba_orden_cancelada RECORD;
    prueba_orden_pendiente RECORD;
BEGIN
	if TG_TABLE_NAME = 'ORDEN_EXITOSA' then
		select into prueba_orden_cancelada * from ORDEN_CANCELADA where id_Ocancelada=new.id_Oexitosa;
		if (prueba_orden_cancelada.id_Ocancelada is not null) then
			raise exception 'La orden % ya pertenece a la subclase orden cancelada',new.id_Oexitosa;
		end if;
		select into prueba_orden_pendiente * from ORDEN_PENDIENTE where id_Opendiente=new.id_Oexitosa;
		if (prueba_orden_pendiente.id_Opendiente is not null) then
			raise exception 'La orden % ya pertenece a la subclase orden pendiente',new.id_Oexitosa;
		end if;
	elseif TG_TABLE_NAME = 'ORDEN_CANCELADA' then
		select into prueba_orden_exitosa * from ORDEN_EXITOSA where id_Oexitosa=new.id_Ocancelada;
		if (prueba_orden_exitosa.id_Oexitosa is not null) then
			raise exception 'La orden % ya pertenece a la subclase orden exitosa',new.id_Ocancelada;
		end if;
		select into prueba_orden_pendiente * from ORDEN_PENDIENTE where id_Opendiente=new.id_Ocancelada;
		if (prueba_orden_pendiente.id_Opendiente is not null) then
			raise exception 'La orden % ya pertenece a la subclase orden pendiente',new.id_Ocancelada;
		end if;
	else
		select into prueba_orden_exitosa * from ORDEN_EXITOSA where id_Oexitosa=new.id_Opendiente;
		if (prueba_orden_exitosa.id_Oexitosa is not null) then
			raise exception 'La orden % ya pertenece a la subclase orden exitosa',new.id_Opendiente;
		end if;
		select into prueba_orden_cancelada * from ORDEN_CANCELADA where id_Ocancelada=new.id_Opendiente;
		if (prueba_orden_cancelada.id_Ocancelada is not null) then
			raise exception 'La orden % ya pertenece a la subclase orden cancelada',new.id_Opendiente;
		end if;
	end if;
	return new;
END;
$$ LANGUAGE plpgsql;

create trigger orden_exitosa_repetida before insert or update on ORDEN_EXITOSA for each row execute procedure orden_ya_esta_en_otra_subclase();
create trigger orden_cancelada_repetida before insert or update on ORDEN_CANCELADA for each row execute procedure orden_ya_esta_en_otra_subclase();
create trigger orden_pendiente_repetida before insert or update on ORDEN_PENDIENTE for each row execute procedure orden_ya_esta_en_otra_subclase();

/*
triggers para la superclase venta
*/
/*
Éste trigger impide todo insert o update directo en la superclase venta no haya sido insertado previamente en alguna de las subclases.
*/
create or replace function comprueba_venta_subclase() returns trigger as $$
DECLARE
	prueba_venta_exitosa RECORD;
	prueba_venta_pendiente RECORD;
BEGIN
	select into prueba_venta_exitosa * from VENTA_EXITOSA where id_venta_exitosa=new.id_venta;
	select into prueba_venta_pendiente * from VENTA_PENDIENTE where id_venta_pendiente=new.id_venta;
	if (prueba_venta_exitosa.id_venta_exitosa is null and prueba_venta_pendiente.id_venta_pendiente is null)
		then
			raise exception 'La venta con el id: % no está introducida en ninguna subclase',new.id_venta;
	else
		return new;
	end if;
END;
$$ LANGUAGE plpgsql;

create trigger venta_en_subclase before insert or update on VENTA for each row execute procedure comprueba_venta_subclase();

/*
Éste trigger elimina automaticamente de la superclase si se elimina una venta de una subclase
*/
create or replace function borrar_venta_superclase() returns trigger as $$
BEGIN
	if TG_TABLE_NAME = 'VENTA_EXITOSA' then
		delete from VENTA where id_venta=old.id_venta_exitosa;
		raise notice 'Al borrar la venta con id: % de % la hemos borrado como venta',old.id_venta_exitosa,TG_TABLE_NAME;
		return old;
	else
		delete from VENTA where id_venta=old.id_venta_pendiente;
		raise notice 'Al borrar la venta con id: % de % la hemos borrado como venta',old.id_venta_pendiente,TG_TABLE_NAME;
		return old;
	end if;
END;
$$ LANGUAGE plpgsql;

create trigger borrar_venta_exitosa after delete on VENTA_EXITOSA for each row execute procedure borrar_venta_superclase();
create trigger borrar_venta_pendiente after delete on VENTA_PENDIENTE for each row execute procedure borrar_venta_superclase();

/*
Éste trigger evita que exista el mismo objeto en más de una subclase
*/
create or replace function venta_ya_esta_en_otra_subclase() returns trigger as $$
DECLARE
	prueba_venta_exitosa RECORD;
	prueba_venta_pendiente RECORD;
BEGIN
	if TG_TABLE_NAME = 'VENTA_EXITOSA' then
		select into prueba_venta_pendiente * from VENTA_PENDIENTE where id_venta_pendiente=new.id_venta_exitosa;
		if (prueba_soporte.id_venta_pendiente is not null) then
			raise exception 'La venta con id: % ya pertenece a venta exitosa',new.id_venta_exitosa;
		end if;
	else
		select into prueba_venta_exitosa * from VENTA_EXITOSA where id_venta_exitosa=new.id_venta_pendiente;
		if (prueba_docente.id_venta_exitosa is not null) then
			raise exception 'La venta con id: % ya pertenece a venta pendiente',new.id_venta_pendiente;
		end if;
	end if;
	return new;
END;
$$ LANGUAGE plpgsql;

create trigger venta_exitosa_repetida before insert or update on VENTA_EXITOSA for each row execute procedure venta_ya_esta_en_otra_subclase();
create trigger venta_pendiente_repetida before insert or update on VENTA_PENDIENTE for each row execute procedure venta_ya_esta_en_otra_subclase();

/* Se ha decidido estandarizar los códigos de los usuarios según la siguiente estructura: (Letra-Año-Iterativo) donde 
  Letra = C (Comprador), V (Vendedor) y R (Repartidor)
  Año = año de la creación, 4 dígitos
  Iterativo = número incremental según coincidencia de Letra-Año
  Ejemplo: C-2020-1
*/
CREATE OR REPLACE FUNCTION nuevo_codigo_usuario(tipo_usuario varchar) RETURNS varchar AS $$
DECLARE
	numero smallint;
	codigocons VARCHAR(8);
	anio CHAR(4);
BEGIN
	IF (tipo_usuario='C' OR tipo_usuario='V' OR tipo_usuario='R')
	THEN
		SELECT INTO anio extract(year FROM CURRENT_DATE);

		SELECT max(substring(id FROM '-.*-(.*)$')::smallint) INTO numero FROM USUARIO WHERE id LIKE tipo_usuario || '-' || anio || '%';

		IF numero IS NULL THEN
            numero:=1;
		ELSE
            numero:=numero+1;
        END IF;
	
		codigocons:=tipo_usuario || '-' || anio || '-' || numero;
		
		RAISE NOTICE 'Nuevo código: %',codigocons;
		RETURN codigocons;
	ELSE
		RAISE EXCEPTION 'El tipo de usuario % no es válido', tipo_usuario;
	END IF;
END;
$$ LANGUAGE plpgsql;

/*
pruebas:
select * from nuevo_codigo_usuario('C');
select * from nuevo_codigo_usuario('K');
*/

-- Función para comprobar la corrección del id ante inserción o actualización
CREATE OR REPLACE FUNCTION id_usuario_correcto() RETURNS trigger AS $$
DECLARE
	anio smallint;
	anioact smallint;
	tipo VARCHAR;
	codigocons VARCHAR(8);
	partenumero VARCHAR;
	numero smallint;
	id_usuario USUARIO.id%TYPE;
BEGIN
	tipo:=split_part(NEW.id, '-', 1); 
	IF (char_length(tipo)!=1 OR (tipo!='C' AND tipo!='V' AND tipo!='R'))
	THEN
		RAISE EXCEPTION 'El tipo de usuario % no es válido', tipo;
	ELSE
		SELECT INTO anioact extract(year from CURRENT_DATE); 
		
		anio:=split_part(NEW.id, '-', 2)::smallint; 

		SELECT INTO id_usuario id FROM USUARIO WHERE anio=split_part(id, '-', 2)::smallint LIMIT 1;

		IF (anio!=anioact)
		THEN
			RAISE EXCEPTION 'El año del usuario % no es válido', anio;
		ELSE
			partenumero:=split_part(NEW.id, '-', 3);

			BEGIN
				numero:=to_number(partenumero,'9');
                EXCEPTION WHEN data_exception THEN
				RAISE EXCEPTION 'El numero incremental de usuario % no es válido', partenumero;
			END;
		END IF;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create trigger id_usuario_correcto BEFORE INSERT OR UPDATE ON USUARIO FOR EACH ROW EXECUTE PROCEDURE id_usuario_correcto();

/*
pruebas: 

BEGIN;

SET CONSTRAINTS fk_comprador DEFERRED;

insert into COMPRADOR values(nuevo_codigo_usuario('C'),'0','asdf@crowingrooster.com');
insert into USUARIO values (nuevo_codigo_usuario('C'),'comprador','luis','12345','Comprador','img');


COMMIT;
*/