--triggers para la superclase usuario
--este trigger impide que todo insert o update directo en la superclase usuario no haya sido insertado previamente en alguna de las subclases.
create or replace function comprueba_usuario_subclase() returns trigger as $$
declare
    prueba_repartidor record;
    prueba_comprador record;
    prueba_vendedor record;
begin
    select into prueba_repartidor * from repartidor where codigo=new.id;
    select into prueba_comprador * from comprador where codigo=new.id;
    select into prueba_vendedor * from vendedor where codigo=new.id;
    if (prueba_repartidor.codigo is null and prueba_comprador.codigo is null and prueba_vendedor.codigo is null)
        then
            raise exception 'el usuario % no está introducido en ninguna subclase', new.id;
    else
        return new;
    end if;
end;
$$ language plpgsql;

create trigger usuario_en_subclase before insert or update on usuario for each row execute procedure comprueba_usuario_subclase();

--este trigger elimina automaticamente de la superclase si se elimina el usuario de una subclase
create or replace function borrar_usuario_superclase() returns trigger as $$
begin
	if tg_relname = 'comprador' then
		delete from usuario where id=old.codigo;
		raise notice 'al borrar a % de % lo hemos borrado como usuario',old.codigo,tg_relname;
		return old;
	elseif tg_relname = 'vendedor' then
		delete from usuario where id=old.codigo;
		raise notice 'al borrar a % de % lo hemos borrado como usuario',old.codigo,tg_relname;
		return old;
	else
		delete from usuario where id=old.codigo;
		raise notice 'al borrar a % de % lo hemos borrado como usuario',old.codigo,tg_relname;
		return old;
	end if;
end;
$$ language plpgsql;

create trigger borrar_usuario_comprador after delete on comprador for each row execute procedure borrar_usuario_superclase();
create trigger borrar_usuario_vendedor after delete on vendedor for each row execute procedure borrar_usuario_superclase();
create trigger borrar_usuario_repartidor after delete on repartidor for each row execute procedure borrar_usuario_superclase();

--este trigger evita que exista el mismo objeto en más de una subclase
create or replace function usuario_ya_esta_en_otra_subclase() returns trigger as $$
declare
	prueba_comprador record;
	prueba_vendedor record;
	prueba_repartidor record;
begin
	if tg_relname = 'comprador' then
		select into prueba_vendedor * from vendedor where codigo=new.codigo;
		if (prueba_vendedor.codigo is not null) then
			raise exception 'el usuario % ya pertenece a la subclase vendedor',new.codigo;
		end if;
		select into prueba_repartidor * from repartidor where codigo=new.codigo;
		if (prueba_repartidor.codigo is not null) then
			raise exception 'el usuario % ya pertenece a la subclase repartidor',new.codigo;
		end if;
	elseif tg_relname = 'vendedor' then
		select into prueba_comprador * from comprador where codigo=new.codigo;
		if (prueba_comprador.codigo is not null) then
			raise exception 'el usuario % ya pertenece a la subclase comprador',new.codigo;
		end if;
		select into prueba_repartidor * from repartidor where codigo=new.codigo;
		if (prueba_repartidor.codigo is not null) then
			raise exception 'el usuario % ya pertenece a la subclase repartidor',new.codigo;
		end if;
	else
		select into prueba_comprador * from comprador where codigo=new.codigo;
		if (prueba_comprador.codigo is not null) then
			raise exception 'el usuario % ya pertenece a la subclase comprador',new.codigo;
		end if;
		select into prueba_vendedor * from vendedor where codigo=new.codigo;
		if (prueba_vendedor.codigo is not null) then
			raise exception 'el usuario % ya pertenece a la subclase vendedor',new.codigo;
		end if;
	end if;
	return new;
end;
$$ language plpgsql;

create trigger usuario_comprador_repetido before insert or update on comprador for each row execute procedure usuario_ya_esta_en_otra_subclase();
create trigger usuario_vendedor_repetido before insert or update on vendedor for each row execute procedure usuario_ya_esta_en_otra_subclase();
create trigger usuario_repartidor_repetido before insert or update on repartidor for each row execute procedure usuario_ya_esta_en_otra_subclase();
 
--triggers para la superclase orden
--este trigger impide que todo insert o update directo en la superclase orden no haya sido insertado previamente en alguna de las subclases.
create or replace function comprueba_orden_subclase() returns trigger as $$
declare
    prueba_orden_exitosa record;
    prueba_orden_cancelada record;
    prueba_orden_pendiente record;
begin
    select into prueba_orden_exitosa * from orden_exitosa where id_oexitosa=new.codigo_orden;
    select into prueba_orden_cancelada * from orden_cancelada where id_ocancelada=new.codigo_orden;
    select into prueba_orden_pendiente * from orden_pendiente where id_opendiente=new.codigo_orden;
    if (prueba_orden_exitosa.id_oexitosa is null and prueba_orden_cancelada.id_ocancelada is null and prueba_orden_pendiente.id_opendiente is null)
        then
            raise exception 'la orden % no está introducida en ninguna subclase', new.codigo_orden;
    else
        return new;
    end if;
end;
$$ language plpgsql;

create trigger orden_en_subclase before insert or update on orden for each row execute procedure comprueba_orden_subclase();

--este trigger evita que exista el mismo objeto en más de una subclase
create or replace function orden_ya_esta_en_otra_subclase() returns trigger as $$
declare
    prueba_orden_exitosa record;
    prueba_orden_cancelada record;
    prueba_orden_pendiente record;
begin
	if tg_relname = 'orden_exitosa' then
		select into prueba_orden_cancelada * from orden_cancelada where id_ocancelada=new.id_oexitosa;
		if (prueba_orden_cancelada.id_ocancelada is not null) then
			raise exception 'la orden % ya pertenece a la subclase orden cancelada',new.id_oexitosa;
		end if;
		select into prueba_orden_pendiente * from orden_pendiente where id_opendiente=new.id_oexitosa;
		if (prueba_orden_pendiente.id_opendiente is not null) then
			raise exception 'la orden % ya pertenece a la subclase orden pendiente',new.id_oexitosa;
		end if;
	elseif tg_relname = 'orden_cancelada' then
		select into prueba_orden_exitosa * from orden_exitosa where id_oexitosa=new.id_ocancelada;
		if (prueba_orden_exitosa.id_oexitosa is not null) then
			raise exception 'la orden % ya pertenece a la subclase orden exitosa',new.id_ocancelada;
		end if;
		select into prueba_orden_pendiente * from orden_pendiente where id_opendiente=new.id_ocancelada;
		if (prueba_orden_pendiente.id_opendiente is not null) then
			raise exception 'la orden % ya pertenece a la subclase orden pendiente',new.id_ocancelada;
		end if;
	elseif tg_relname = 'orden_pendiente' then
		select into prueba_orden_exitosa * from orden_exitosa where id_oexitosa=new.id_opendiente;
		if (prueba_orden_exitosa.id_oexitosa is not null) then
			raise exception 'la orden % ya pertenece a la subclase orden exitosa',new.id_opendiente;
		end if;
		select into prueba_orden_cancelada * from orden_cancelada where id_ocancelada=new.id_opendiente;
		if (prueba_orden_cancelada.id_ocancelada is not null) then
			raise exception 'la orden % ya pertenece a la subclase orden cancelada',new.id_opendiente;
		end if;
	end if;
	return new;
end;
$$ language plpgsql;

create trigger orden_exitosa_repetida before insert or update on orden_exitosa for each row execute procedure orden_ya_esta_en_otra_subclase();
create trigger orden_cancelada_repetida before insert or update on orden_cancelada for each row execute procedure orden_ya_esta_en_otra_subclase();
create trigger orden_pendiente_repetida before insert or update on orden_pendiente for each row execute procedure orden_ya_esta_en_otra_subclase();

--triggers para la superclase venta:
--este trigger impide todo insert o update directo en la superclase venta no haya sido insertado previamente en alguna de las subclases.
create or replace function comprueba_venta_subclase() returns trigger as $$
declare
	prueba_venta_exitosa record;
	prueba_venta_pendiente record;
begin
	select into prueba_venta_exitosa * from venta_exitosa where id_venta_exitosa=new.id_venta;
	select into prueba_venta_pendiente * from venta_pendiente where id_venta_pendiente=new.id_venta;
	if (prueba_venta_exitosa.id_venta_exitosa is null and prueba_venta_pendiente.id_venta_pendiente is null)
		then
			raise exception 'la venta con el id: % no está introducida en ninguna subclase',new.id_venta;
	else
		return new;
	end if;
end;
$$ language plpgsql;

create trigger venta_en_subclase before insert or update on venta for each row execute procedure comprueba_venta_subclase();

--este trigger evita que exista el mismo objeto en más de una subclase
create or replace function venta_ya_esta_en_otra_subclase() returns trigger as $$
declare
	prueba_venta_exitosa record;
	prueba_venta_pendiente record;
begin
	if tg_relname = 'venta_exitosa' then
		select into prueba_venta_pendiente * from venta_pendiente where id_venta_pendiente=new.id_venta_exitosa;
		if (prueba_venta_pendiente.id_venta_pendiente is not null) then
			raise exception 'la venta con id: % ya pertenece a venta pendiente',new.id_venta_exitosa;
		end if;
	elseif tg_relname = 'venta_pendiente' then
		select into prueba_venta_exitosa * from venta_exitosa where id_venta_exitosa=new.id_venta_pendiente;
		if (prueba_venta_exitosa.id_venta_exitosa is not null) then
			raise exception 'la venta con id: % ya pertenece a venta exitosa',new.id_venta_pendiente;
		end if;
	end if;
	return new;
end;
$$ language plpgsql;

create trigger venta_exitosa_repetida before insert or update on venta_exitosa for each row execute procedure venta_ya_esta_en_otra_subclase();
create trigger venta_pendiente_repetida before insert or update on venta_pendiente for each row execute procedure venta_ya_esta_en_otra_subclase();

--se ha decidido estandarizar los códigos de los usuarios según la siguiente estructura: (letra-año-iterativo) donde:
--letra = c (comprador), v (vendedor) y r (repartidor)
--año = año de la creación, 4 dígitos
--iterativo = número incremental según coincidencia de letra-año
--ejemplo: c-2020-1
create or replace function nuevo_codigo_usuario(tipo_usuario varchar) returns varchar as $$
declare
	numero smallint;
	codigocons varchar(8);
	anio char(4);
begin
	if (tipo_usuario='c' or tipo_usuario='v' or tipo_usuario='r')
	then
		select into anio extract(year from current_date);

		select max(substring(id from '-.*-(.*)$')::smallint) into numero from usuario where id like tipo_usuario || '-' || anio || '%';

		if numero is null then
            numero:=1;
		else
            numero:=numero+1;
        end if;
	
		codigocons:=tipo_usuario || '-' || anio || '-' || numero;
		
		raise notice 'nuevo código: %',codigocons;
		return codigocons;
	else
		raise exception 'el tipo de usuario % no es válido', tipo_usuario;
	end if;
end;
$$ language plpgsql;


-- función para comprobar la corrección del id ante inserción o actualización
create or replace function id_usuario_correcto() returns trigger as $$
declare
	anio smallint;
	anioact smallint;
	tipo varchar;
	codigocons varchar(8);
	partenumero varchar;
	numero smallint;
	id_usuario usuario.id%type;
begin
	tipo:=split_part(new.id, '-', 1); 
	if (char_length(tipo)!=1 or (tipo!='c' and tipo!='v' and tipo!='r'))
	then
		raise exception 'el tipo de usuario % no es válido', tipo;
	else
		select into anioact extract(year from current_date); 
		
		anio:=split_part(new.id, '-', 2)::smallint; 

		select into id_usuario id from usuario where anio=split_part(id, '-', 2)::smallint limit 1;

		if (anio!=anioact)
		then
			raise exception 'el año del usuario % no es válido', anio;
		else
			partenumero:=split_part(new.id, '-', 3);

			begin
				numero:=to_number(partenumero,'9');
                exception when data_exception then
				raise exception 'el numero incremental de usuario % no es válido', partenumero;
			end;
		end if;
	end if;
	return new;
end;
$$ language plpgsql;

create trigger id_usuario_correcto before insert or update on usuario for each row execute procedure id_usuario_correcto();

--este trigger escucha los updates con la superclase venta cuando el esta de la venta es alterado y cambia las ventas
--de la subclase venta_pendiente a venta_exitosa
create or replace function cambia_subclase() returns trigger as $$
declare
	prueba_venta record;
	prueba_orden record;
begin
	if (tg_relname= 'venta' and new.estado='Exitosa') then

		select into prueba_venta * from venta_exitosa where id_venta_exitosa=new.id_venta;

		if prueba_venta.id_venta_exitosa is null then 
			delete from venta_pendiente where id_venta_pendiente=new.id_venta;
			insert into venta_exitosa values (new.id_venta, current_date, '12.12', 1); --el precio debe obtenerse de la app
			raise notice 'se ha borrado de venta_pendiente la venta con el id: %, se ha insertado en venta_exitosa y se ha cambiado el estado en % a: %', new.id_venta, tg_relname, new.estado;
		end if;
	elseif (tg_relname = 'orden' and new.estado='Exitosa') then

		select into prueba_orden * from orden_exitosa where id_oexitosa=new.codigo_orden;

		if prueba_orden.id_oexitosa is null then
			delete from orden_pendiente where id_opendiente=new.codigo_orden;
			insert into orden_exitosa values (new.codigo_orden, current_date, (to_char(current_timestamp, 'hh12:mi:ss')), '12.12', 1); -- el precio debe obtenerse de la app o en su defecto de una tabla a la que se pueda acceder esa info.
			raise notice 'se ha borrado de orden_pendiente la orden con el id: %, se ha insertado en orden_exitosa y se ha cambiado es estado en % a: %', new.codigo_orden, tg_relname, new.estado;
		end if;
	elseif (tg_relname = 'orden' and new.estado='Cancelada') then
		select into prueba_orden * from orden_cancelada where id_ocancelada=new.codigo_orden;

		if prueba_orden.id_ocancelada is null then
			delete from orden_pendiente where id_opendiente=new.codigo_orden;
			insert into orden_cancelada values (new.codigo_orden, current_date);
			raise notice 'se ha borrado de orden pendiente la orden con el id: %, se ha insertado en orden_cancelada y se ha cambiado el estado en % a: %', new.codigo_orden, tg_relname, new.estado;
		end if;
	end if;
	return new;
end;
$$ language plpgsql;

drop trigger if exists cambia_venta_subclase on venta;
drop trigger if exists cambia_orden_subclase on orden;
create constraint trigger cambia_venta_subclase after update on venta for each row execute procedure cambia_subclase();
create constraint trigger cambia_orden_subclase after update on orden for each row execute procedure cambia_subclase();

/*
pruebas:
select * from nuevo_codigo_usuario('c');
select * from nuevo_codigo_usuario('k');
*/

/*
pruebas: 

begin;
set constraints fk_comprador deferred;

insert into comprador values(nuevo_codigo_usuario('c'),'0','asdf@crowingrooster.com');
insert into usuario values (nuevo_codigo_usuario('c'),'comprador','luis','12345','Comprador','img');
commit;

begin;
set constraints fk_vendedor deferred;

insert into vendedor values(nuevo_codigo_usuario('v'),'asdf@crowingrooster.com');
insert into usuario values (nuevo_codigo_usuario('v'),'Vendedor','luis','12345','Vendedor','img');
commit;

begin;
set constraints fk_vendedor_codigo deferred;
set constraints fk_venta_pendiente deferred;

insert into venta_pendiente values('1','2020-07-06');
insert into venta values('1','Pendiente','v-2020-1');
commit;

begin;
set constraints fk_comprador_codigo deferred;
set constraints fk_vendedor_codigo deferred;
set constraints fk_orden_pendiente deferred;

insert into orden_pendiente values ('3', current_date);
insert into orden values('3', 'Pendiente', 'v-2020-1', 'c-2020-1');
commit;

prueba para cambia_subclase con ventas
update venta set estado='Exitosa' where id_venta='1';
update venta set estado='pendiente' where id_venta='1';
update orden set estado='Cancelada' where codigo_orden='3';
update orden set estado='pendiente' where codigo_orden='1';

insert into orden_exitosa values ('1', current_date, (to_char(current_timestamp, 'hh12:mi:ss')), '12.12', 1);

*/