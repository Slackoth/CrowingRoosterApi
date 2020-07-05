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
    select into prueba_repartidor * from REPARTIDOR where codigo=new.codigo;
    select into prueba_comprador * from COMPRADOR where codigo=new.codigo;
    select into prueba_vendedor * from VENDEDOR where codigo=new.codigo;
    if (prueba_repartidor.codigo is null and prueba_comprador.codigo is null and prueba_vendedor.codigo is null)
        then
            raise exception 'El usuario % no está introducido en ninguna subclase', new.codigo;
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
    select into prueba_orden_exitosa * from ORDEN_EXITOSA where id_Oexitosa=new.id_orden;
    select into prueba_orden_cancelada * from ORDEN_CANCELADA where id_Ocancelada=new.id_orden;
    select into prueba_orden_pendiente * from ORDEN_PENDIENTE where id_Opendiente=new.id_orden;
    if (prueba_orden_exitosa.id_Oexitosa is null and prueba_orden_cancelada.id_Ocancelada is null and prueba_orden_pendiente.id_Opendiente is null)
        then
            raise exception 'La orden % no está introducida en ninguna subclase', new.id_orden;
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