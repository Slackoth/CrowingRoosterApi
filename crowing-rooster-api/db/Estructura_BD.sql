drop database if exists crowing_rooster; 

create database crowing_rooster; 


drop DOMAIN if exists correo;
create DOMAIN correo as varchar(200) check (value ~ '^\d{8}@(.com)|[a-z]+@(.com)$');

drop table if exists USUARIO cascade; 
create table USUARIO(
	id int not null, 
	usuario text not null, 
	nombre text not null, 
	clave text not null, 
	tipo text not null check (tipo in ('USUARIO','VENDEDOR','REPARTIDOR')),
	img bytea not null	
); 

drop table if exists REPARTIDOR cascade ; 
create table REPARTIDOR(
	codigo int not null,
	telefono int not null
);

drop table if exists COMPRADOR cascade; 
create table COMPRADOR(
	codigo int not null, 
	dui varchar(10) not null, 
	empresa text not null,
	email correo not null, 
	telefono int not null 
); 

drop table if exists VENDEDOR cascade; 
create table VENDEDOR(
	codigo int not null, 
	telefono int not null, 
	email correo not null 
); 

drop table if exists TELEFONO cascade; 
create table TELEFONO(
	id_usuario int not null, 
	telefono int not null, 
	comprador_codigo int not null, 
	vendedor_codigo int not null, 
	repartidor_codigo int not null
); 

drop table if exists EMPRESA cascade; 
create table EMPRESA(
	id_empresa int not null, 
	nombre_empresa text not null, 
	comprador_codigo int not null
); 


drop table if exists VENTA cascade;  
create table VENTA (
	id_venta int not null, 
	estado text not null check (estado in ('VENTA_EXITOSA','VENTA_PENDIENTE')), 
	vendedor_codigo int not null
); 

drop table if exists VENTA_EXITOSA cascade;  
create table VENTA_EXITOSA(
	id_venta_exitosa int not null, 
	fecha_venta date not null, 
	precio money not null
); 

drop table if exists VENTA_PENDIENTE cascade;  
create table VENTA_PENDIENTE(
	id_venta_pendiente int not null, 
	fecha_pedido text not null 
); 

drop table if exists PEDIDO cascade; 
create table PEDIDO(
	numero_pedido int not null, 
	comprador_codigo int not null, 
	numero_orden int not null, 
	id_bateria int not null
); 

drop table if exists ORDEN cascade; 
create table ORDEN(
	numero_orden int not null, 
	estado text not null check (estado in ('ORDEN_EXITOSA','ORDEN_PENDIENTE', 'ORDEN_CANCELADA')), 
	vendedor_codigo int not null, 
	comprador_codigo int not null
); 

drop table if exists ORDEN_EXITOSA cascade;  
create table ORDEN_EXITOSA (
	id_Oexitosa int not null, 
	fecha_entrega date not null, 
	hora_entrega varchar(10) not null, 
	precio_total money not null
); 

drop table if exists ORDEN_CANCELADA cascade;  
create table ORDEN_CANCELADA(
	id_Ocancelada int not null,
	fecha date not null 
); 

drop table if exists ORDEN_PENDIENTE cascade; 
create table ORDEN_PENDIENTE(
	id_Opendiente int not null, 
	fecha date not null 
); 

drop table if exists METODO_PAGO cascade; 
create table METODO_PAGO(
	id_metodo_pago int not null, 
	metodo text not null, 
	venta_exitosa int not null, 
	orden_exitosa int not null
); 

drop table if exists BATERIA cascade; 
create table BATERIA(
	id_bateria int not null, 
	dimensiones text not null, 
	polaridad text not null, 
	capacidad_reserva int not null, 
	calidad text not null, 
	amperaje int not null, 
	CCA int not null 
); 

drop table if exists CALIDAD cascade; 
create table CALIDAD (
	id_calidad int not null, 
	tipo text not null check (tipo in ('Premium','Azul')), 
	id_bateria int not null
); 

drop table if exists POLARIDAD cascade;  
create table POLARIDAD (
	id_polaridad int not null, 
	direccion text not null, 
	id_bateria int not null
); 

drop table if exists ENTREGA cascade;  
create table ENTREGA (
	id_entrega int not null, 
	estado text not null
); 

drop table if exists ESTADO_ENTREGA cascade; 
create table ESTADO_ENTREGA (
	id_estado int not null, 
	estado text not null, 
	id_entrega int not null
); 

drop table if exists REPARTIDORxENTREGA cascade; 
create table REPARTIDORxENTREGA(
	codigo_repartidor int not null, 
	id_entrega int not null
); 

drop table if exists VENTA_EXITOSAxENTREGA cascade;  
create table VENTA_EXITOSAxENTREGA(
	id_venta_exitosa int not null, 
	id_entrega int not null, 
	direccion_entrega text not null, 
	hora_entrega text not null
); 


-------------------------------------------------COMIENZO-DE-ALTER-TABLES-----------------------------

---USUARIO
alter table USUARIO add constraint pk_usuario primary key (id);

---REPARTIDOR 
alter table REPARTIDOR add constraint pk_repartidor primary key (codigo);

---COMPRADOR
alter table COMPRADOR add constraint pk_comprador primary key(codigo); 

---VENDEDPOR
alter table VENDEDOR add constraint pk_vendedor primary key(codigo); 

---TELEFONO
alter table TELEFONO add constraint pk_telefono primary key(id_usuario); 
alter table TELEFONO add constraint fk_comprador_codigo foreign key (comprador_codigo) references COMPRADOR(codigo) on delete cascade on update cascade deferrable; 
alter table TELEFONO add constraint fk_vendedor_codigo foreign key (vendedor_codigo) references VENDEDOR(codigo) on delete cascade on update cascade deferrable; 
alter table TELEFONO add constraint fk_repartidor_codigo foreign key (repartidor_codigo) references REPARTIDOR(codigo) on delete cascade on update cascade deferrable; 


---EMPRESA
alter table EMPRESA add constraint pk_empresa primary key(id_empresa);
alter table EMPRESA add constraint fk_comprador_codigo foreign key (comprador_codigo) references COMPRADOR(codigo) on delete cascade on update cascade deferrable; 

---VENTA
alter table VENTA add constraint pk_venta primary key(id_venta); 
alter table VENTA add constraint fk_vendedor_codigo foreign key (vendedor_codigo) references VENDEDOR(codigo) on delete cascade on update cascade deferrable; 

---VENTA EXITOSA
alter table VENTA_EXITOSA add constraint pk_venta_exitosa primary key(id_venta_exitosa); 

---VENTA PENDIENTE
alter table VENTA_PENDIENTE add constraint pk_venta_pendiente primary key(id_venta_pendiente); 

---BATERIA
alter table BATERIA add constraint pk_bateria primary key(id_bateria); 

---ORDEN 
alter table ORDEN add constraint pk_orden primary key(numero_orden); 
alter table ORDEN add constraint fk_comprador_codigo foreign key (comprador_codigo) references COMPRADOR(codigo) on delete cascade on update cascade deferrable; 
alter table ORDEN add constraint fk_vendedor_codigo foreign key (vendedor_codigo) references VENDEDOR(codigo) on delete cascade on update cascade deferrable;

---ORDEN EXITOSA
alter table ORDEN_EXITOSA add constraint pk_orden_exitosa primary key(id_Oexitosa); 

---ORDEN CANCELADA
alter table ORDEN_CANCELADA add constraint pk_orden_cancelada primary key(id_Ocancelada); 

---ORDEN PENDIENTE
alter table ORDEN_PENDIENTE add constraint pk_orden_pendiente primary key(id_Opendiente); 

---PEDIDO
alter table PEDIDO add constraint pk_numero_pedido primary key(numero_pedido); 
alter table PEDIDO add constraint fk_comprador_codigo foreign key (comprador_codigo) references COMPRADOR(codigo) on delete cascade on update cascade deferrable; 
alter table PEDIDO add constraint fk_numero_orden foreign key (numero_orden) references ORDEN(numero_orden) on delete cascade on update cascade deferrable; 
alter table PEDIDO add constraint fk_id_bateria foreign key (id_bateria) references BATERIA(id_bateria) on delete cascade on update cascade deferrable; 

--METODO DE PAGO
alter table METODO_PAGO add constraint pk_metodo_pago primary key(id_metodo_pago); 

alter table METODO_PAGO add constraint fk_venta_exitosa foreign key (venta_exitosa) references VENTA_EXITOSA(id_venta_exitosa) on delete cascade on update cascade deferrable; 
alter table METODO_PAGO add constraint fk_orden_exitosa foreign key (orden_exitosa) references ORDEN_EXITOSA(id_Oexitosa) on delete cascade on update cascade deferrable; 

---CALIDAD
alter table CALIDAD add constraint pk_calidad primary key(id_calidad); 
alter table CALIDAD add constraint fk_id_bateria foreign key (id_bateria) references BATERIA(id_bateria) on delete cascade on update cascade deferrable; 

---POLARIDAD
alter table POLARIDAD add constraint pk_polaridad primary key(id_polaridad); 
alter table POLARIDAD add constraint fk_id_bateria foreign key (id_bateria) references BATERIA(id_bateria) on delete cascade on update cascade deferrable; 

---ENTREGA
alter table ENTREGA add constraint pk_entrega primary key(id_entrega); 

---ESTADO_ENTREGA
alter table ESTADO_ENTREGA add constraint pk_estado_entrega primary key(id_estado);
alter table ESTADO_ENTREGA add constraint fk_id_entrega foreign key (id_entrega) references ENTREGA(id_entrega) on delete cascade on update cascade deferrable;

---REPARTIDORxENTREGA
alter table REPARTIDORxENTREGA add constraint pk_REPARTIDORxENTREGA primary key(codigo_repartidor, id_entrega);
alter table REPARTIDORxENTREGA add constraint fk_codigo_repartidor foreign key (codigo_repartidor) references REPARTIDOR(codigo) on delete cascade on update cascade deferrable; 
alter table REPARTIDORxENTREGA add constraint fk_codigo_entrega foreign key (id_entrega) references ENTREGA(id_entrega) on delete cascade on update cascade deferrable; 

---VENTA_EXITOSAxENTREGA
alter table VENTA_EXITOSAxENTREGA add constraint pk_VENTA_EXITOSAxENTREGA primary key(id_venta_exitosa, id_entrega);
alter table VENTA_EXITOSAxENTREGA add constraint fk_VENTA_EXITOSA foreign key (id_entrega) references VENTA_EXITOSA(id_venta_exitosa) on delete cascade on update cascade deferrable; 
alter table VENTA_EXITOSAxENTREGA add constraint fk_id_ENTREGA foreign key (id_entrega) references ENTREGA(id_entrega) on delete cascade on update cascade deferrable; 


