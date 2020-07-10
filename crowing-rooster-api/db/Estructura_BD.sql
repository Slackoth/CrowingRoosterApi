\c template1

drop database if exists crowing_rooster; 
create database crowing_rooster; 

\c crowing_rooster

drop DOMAIN if exists correo cascade;
--create DOMAIN correo as varchar(200) check (value ~ '^\d{8}@(.com)|[a-z]+@(.com)$');
create DOMAIN correo as varchar(200)
check ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

drop table if exists USUARIO cascade; 
create table USUARIO(
	id varchar(100) not null, 
	usuario text not null, 
	nombre text not null, 
	clave text not null,
	tipo text not null check (tipo in ('Comprador','Vendedor','Repartidor')),
	img text not null	
); 

drop table if exists REPARTIDOR cascade ; 
create table REPARTIDOR(
	codigo varchar(100) not null,
	email correo not null
);

drop table if exists COMPRADOR cascade; 
create table COMPRADOR(
	codigo varchar(100) not null, 
	dui varchar(10) not null, 
	email correo not null, 
	id_empresa int
); 

drop table if exists VENDEDOR cascade; 
create table VENDEDOR(
	codigo varchar(100) not null, 
	email correo not null
); 

drop table if exists TELEFONO cascade; 
create table TELEFONO(
	id_telefono serial not null, 
	telefono varchar(10) not null, 
	comprador_codigo varchar(100), 
	vendedor_codigo varchar(100), 
	repartidor_codigo varchar(100)
); 

drop table if exists EMPRESA cascade; 
create table EMPRESA(
	id_empresa serial  not null, 
	nombre_empresa text not null
); 


drop table if exists VENTA cascade;  
create table VENTA (
	id_venta varchar(100) not null, 
	estado text not null check (estado in ('Exitosa','Pendiente')), 
	vendedor_codigo varchar(100) not null
); 

drop table if exists METODO_PAGO cascade; 
create table METODO_PAGO(
	id_metodo_pago serial not null, 
	metodo text not null
);

drop table if exists VENTA_EXITOSA cascade;  
create table VENTA_EXITOSA(
	id_venta_exitosa varchar(100) not null,
	fecha_venta date not null, 
	precio money not null, 
	metodo_pago int not null 
); 

drop table if exists VENTA_PENDIENTE cascade;  
create table VENTA_PENDIENTE(
	id_venta_pendiente varchar(100) not null,
	fecha_pedido text not null
); 
 
drop table if exists CALIDAD cascade; 
create table CALIDAD (
	id_calidad serial not null, 
	tipo text not null check (tipo in ('Premium','Standard'))
); 

drop table if exists POLARIDAD cascade;  
create table POLARIDAD (
	id_polaridad serial not null, 
	direccion text not null check (direccion in ('Izquierda','Derecha'))
); 

drop table if exists BATERIA cascade; 
create table BATERIA(
	id_bateria serial not null,
	modelo text not null,
	dimensiones text not null, 
	polaridad int not null, 
	capacidad_reserva int not null, 
	calidad int not null, 
	amperaje int not null, 
	CCA int not null ,
	product_img text not null
); 

drop table if exists ORDEN cascade; 
create table ORDEN(
	codigo_orden varchar(100) not null, 
	estado text not null check (estado in ('Exitosa','Pendiente', 'Cancelada'))
);

drop table if exists ORDEN_EXITOSA cascade;  
create table ORDEN_EXITOSA (
	id_Oexitosa varchar(100) not null, 
	fecha_entrega date not null, 
	hora_entrega varchar(10) not null, 
	precio_total money not null, 
	metodo_pago int not null 
); 

drop table if exists ORDEN_CANCELADA cascade;  
create table ORDEN_CANCELADA(
	id_Ocancelada varchar(100) not null, 
	fecha_cancelada date not null 
); 

drop table if exists ORDEN_PENDIENTE cascade; 
create table ORDEN_PENDIENTE(
	id_Opendiente varchar(100) not null,
	fecha_pendiente date not null 
); 

drop table if exists PEDIDO cascade; 
create table PEDIDO(
	numero_pedido serial, 
	comprador_codigo varchar(10) not null,
	cantidad_bateria int not null,
	codigo_orden varchar(100) not null, 
	id_bateria int not null
); 


drop table if exists ENTREGA cascade;  
create table ENTREGA (
	id_entrega serial not null, 
	id_estado int not null
); 

drop table if exists ESTADO_ENTREGA cascade; 
create table ESTADO_ENTREGA (
	id_estado serial not null, 
	estado text not null
); 

drop table if exists REPARTIDORxENTREGA cascade; 
create table REPARTIDORxENTREGA(
	codigo_repartidor varchar(10) not null, 
	id_entrega int not null
); 

drop table if exists VENTA_EXITOSAxENTREGA cascade;  
create table VENTA_EXITOSAxENTREGA(
	id_venta_exitosa varchar(100) not null, 
	id_entrega int not null, 
	direccion_entrega text not null, 
	hora_entrega text not null
); 

drop table if exists VENTAxORDEN cascade;
create table VENTAxORDEN(
	id_venta_ventaxorden varchar (100) not null,
	id_orden_ventaxorden varchar (100) not null
);

-------------------------------------------------COMIENZO-DE-ALTER-TABLES-----------------------------

---USUARIO
alter table USUARIO add constraint pk_usuario primary key (id);

---REPARTIDOR 
alter table REPARTIDOR add constraint pk_repartidor primary key (codigo);
alter table REPARTIDOR add constraint fk_repartidor foreign key (codigo) references USUARIO(id) on delete cascade on update cascade deferrable; 

---EMPRESA
alter table EMPRESA add constraint pk_empresa primary key(id_empresa);

---COMPRADOR
alter table COMPRADOR add constraint pk_comprador primary key(codigo);
alter table COMPRADOR add constraint fk_comprador foreign key (codigo) references USUARIO(id) on delete cascade on update cascade deferrable; 
alter table COMPRADOR add constraint fk_empresa foreign key (id_empresa) references EMPRESA(id_empresa) on delete cascade on update cascade deferrable; 

---VENDEDOR
alter table VENDEDOR add constraint pk_vendedor primary key(codigo); 
alter table VENDEDOR add constraint fk_vendedor foreign key (codigo) references USUARIO(id) on delete cascade on update cascade deferrable;  

---TELEFONO
alter table TELEFONO add constraint pk_telefono primary key(id_telefono); 

alter table TELEFONO add constraint fk_comprador_codigo foreign key (comprador_codigo) references COMPRADOR(codigo) on delete cascade on update cascade deferrable; 
alter table TELEFONO add constraint fk_vendedor_codigo foreign key (vendedor_codigo) references VENDEDOR(codigo) on delete cascade on update cascade deferrable; 
alter table TELEFONO add constraint fk_repartidor_codigo foreign key (repartidor_codigo) references REPARTIDOR(codigo) on delete cascade on update cascade deferrable; 

---VENTA
alter table VENTA add constraint pk_venta primary key(id_venta); 
alter table VENTA add constraint fk_vendedor_codigo foreign key (vendedor_codigo) references VENDEDOR(codigo) on delete cascade on update cascade deferrable; 

--METODO DE PAGO
alter table METODO_PAGO add constraint pk_metodo_pago primary key(id_metodo_pago);  

---VENTA EXITOSA
alter table VENTA_EXITOSA add constraint pk_venta_exitosa primary key(id_venta_exitosa); 
alter table VENTA_EXITOSA add constraint fk_venta_exitosa foreign key (id_venta_exitosa) references VENTA(id_venta) on delete cascade on update cascade deferrable; 
alter table VENTA_EXITOSA add constraint fk_metado_pago foreign key (metodo_pago) references METODO_PAGO(id_metodo_pago) on delete cascade on update cascade deferrable; 

---VENTA PENDIENTE
alter table VENTA_PENDIENTE add constraint pk_venta_pendiente primary key(id_venta_pendiente); 
alter table VENTA_PENDIENTE add constraint fk_venta_pendiente foreign key (id_venta_pendiente) references VENTA(id_venta) on delete cascade on update cascade deferrable; 

---CALIDAD
alter table CALIDAD add constraint pk_calidad primary key(id_calidad); 

---POLARIDAD
alter table POLARIDAD add constraint pk_polaridad primary key(id_polaridad); 

---BATERIA
alter table BATERIA add constraint pk_bateria primary key(id_bateria); 
alter table BATERIA add constraint fk_polaridad foreign key (polaridad) references POLARIDAD(id_polaridad) on delete cascade on update cascade deferrable;
alter table BATERIA add constraint fk_calidad foreign key (calidad) references CALIDAD(id_calidad) on delete cascade on update cascade deferrable;

---ORDEN 
alter table ORDEN add constraint pk_orden primary key(codigo_orden); 

---ORDEN EXITOSA
alter table ORDEN_EXITOSA add constraint pk_orden_exitosa primary key(id_Oexitosa); 
alter table ORDEN_EXITOSA add constraint fk_orden_exitosa foreign key (id_Oexitosa) references ORDEN(codigo_orden) on delete cascade on update cascade deferrable; 
alter table ORDEN_EXITOSA add constraint fk_metodo_pago foreign key (metodo_pago) references METODO_PAGO(id_metodo_pago) on delete cascade on update cascade deferrable; 

---ORDEN CANCELADA
alter table ORDEN_CANCELADA add constraint pk_orden_cancelada primary key(id_Ocancelada); 
alter table ORDEN_CANCELADA add constraint fk_orden_cancelada foreign key (id_Ocancelada) references ORDEN(codigo_orden) on delete cascade on update cascade deferrable; 

---ORDEN PENDIENTE
alter table 	_PENDIENTE add constraint pk_orden_pendiente primary key(id_Opendiente); 
alter table ORDEN_PENDIENTE add constraint fk_orden_pendiente foreign key (id_Opendiente) references ORDEN(codigo_orden) on delete cascade on update cascade deferrable; 

---PEDIDO
alter table PEDIDO add constraint pk_numero_pedido primary key(numero_pedido); 
alter table PEDIDO add constraint fk_id_bateria foreign key (id_bateria) references BATERIA(id_bateria) on delete cascade on update cascade deferrable; 
alter table PEDIDO add constraint fk_codigo_orden foreign key (codigo_orden) references ORDEN(codigo_orden) on delete cascade on update cascade deferrable; 
alter table PEDIDO add constraint fk_compador_codigo foreign key (comprador_codigo) references COMPRADOR(codigo) on delete cascade on update cascade deferrable;

---ESTADO_ENTREGA
alter table ESTADO_ENTREGA add constraint pk_estado_entrega primary key(id_estado);

---ENTREGA
alter table ENTREGA add constraint pk_entrega primary key(id_entrega); 
alter table ENTREGA add constraint fk_id_estado foreign key (id_estado) references ESTADO_ENTREGA(id_estado) on delete cascade on update cascade deferrable;

---REPARTIDORxENTREGA
alter table REPARTIDORxENTREGA add constraint pk_REPARTIDORxENTREGA primary key(codigo_repartidor, id_entrega);
alter table REPARTIDORxENTREGA add constraint fk_codigo_repartidor foreign key (codigo_repartidor) references REPARTIDOR(codigo) on delete cascade on update cascade deferrable; 
alter table REPARTIDORxENTREGA add constraint fk_codigo_entrega foreign key (id_entrega) references ENTREGA(id_entrega) on delete cascade on update cascade deferrable; 

---VENTA_EXITOSAxENTREGA
alter table VENTA_EXITOSAxENTREGA add constraint pk_VENTA_EXITOSAxENTREGA primary key(id_venta_exitosa, id_entrega);
alter table VENTA_EXITOSAxENTREGA add constraint fk_VENTA_EXITOSA foreign key (id_venta_exitosa) references VENTA_EXITOSA(id_venta_exitosa) on delete cascade on update cascade deferrable; 
alter table VENTA_EXITOSAxENTREGA add constraint fk_id_ENTREGA foreign key (id_entrega) references ENTREGA(id_entrega) on delete cascade on update cascade deferrable; 

-- VENTAXORDEN
alter table VENTAxORDEN add constraint pk_ventaxorden primary key(id_venta_ventaxorden, id_orden_ventaxorden);
alter table VENTAxORDEN add constraint fk_id_venta_ventaxorden foreign key (id_venta_ventaxorden) references VENTA(id_venta) on delete cascade on update cascade deferrable;
alter table VENTAxORDEN add constraint fk_id_orden_ventaxorden foreign key (id_orden_ventaxorden) references ORDEN(codigo_orden) on delete cascade on update cascade deferrable;
