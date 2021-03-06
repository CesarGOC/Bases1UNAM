PGDMP     %                     y         
   GHOSTPAPER    13.1    13.1 @               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16510 
   GHOSTPAPER    DATABASE     h   CREATE DATABASE "GHOSTPAPER" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE "GHOSTPAPER";
                postgres    false            �            1255    16511    buscar_nombre()    FUNCTION     �   CREATE FUNCTION public.buscar_nombre() RETURNS TABLE(nombre character varying)
    LANGUAGE sql
    AS $$
SELECT nombre
FROM producto
WHERE stock<3;
$$;
 &   DROP FUNCTION public.buscar_nombre();
       public          postgres    false            �            1255    16512    buscar_utilidad(integer)    FUNCTION     �   CREATE FUNCTION public.buscar_utilidad(codigo1 integer) RETURNS money
    LANGUAGE sql
    AS $$
SELECT precio
FROM producto
WHERE codigo=codigo1;
$$;
 7   DROP FUNCTION public.buscar_utilidad(codigo1 integer);
       public          postgres    false            �            1255    16513    cantidad_total_ventas(date)    FUNCTION     �   CREATE FUNCTION public.cantidad_total_ventas(fecha_ingresada date) RETURNS money
    LANGUAGE sql
    AS $$
SELECT SUM(precio_total) FROM venta WHERE fecha_venta=fecha_ingresada
$$;
 B   DROP FUNCTION public.cantidad_total_ventas(fecha_ingresada date);
       public          postgres    false            �            1255    16643 h   compra_cantidad(character varying, money, character varying, integer, money, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.compra_cantidad(concepto1 character varying, precio_total1 money, rfc1 character varying, cod1 integer, precio_can1 money, can1 integer, direccion character varying) RETURNS timestamp with time zone
    LANGUAGE plpgsql
    AS $$
DECLARE
	var1 integer;
	fec timestamp with time zone;
BEGIN
SELECT CURRENT_TIMESTAMP INTO fec; 

INSERT INTO public.venta(concepto, precio_total, fecha_venta, rfc,direccion_de_envío)
	VALUES (concepto1, precio_total1, fec, rfc1,direccion);
	
SELECT noventa INTO var1 FROM venta WHERE precio_total=precio_total1 AND rfc=rfc1 AND fecha_venta=fec;
INSERT INTO public.consta(codigo_fk, noventa_fk, "precioXcantidad", cantidad)
	VALUES (cod1, var1, precio_can1, can1);
	
return fec;

END;
$$;
 �   DROP FUNCTION public.compra_cantidad(concepto1 character varying, precio_total1 money, rfc1 character varying, cod1 integer, precio_can1 money, can1 integer, direccion character varying);
       public          postgres    false            �            1255    16657 i   compra_cantidad_(character varying, money, character varying, integer, money, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.compra_cantidad_(concepto1 character varying, precio_total1 money, rfc1 character varying, cod1 integer, precio_can1 money, can1 integer, direccion character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	var1 integer;
	fec timestamp with time zone;
BEGIN
SELECT CURRENT_TIMESTAMP INTO fec; 

INSERT INTO public.venta(concepto, precio_total, fecha_venta, rfc,direccion_de_envío)
	VALUES (concepto1, precio_total1, fec, rfc1,direccion);
	
SELECT noventa INTO var1 FROM venta WHERE precio_total=precio_total1 AND rfc=rfc1 AND fecha_venta=fec;
INSERT INTO public.consta(codigo_fk, noventa_fk, "precioXcantidad", cantidad)
	VALUES (cod1, var1, precio_can1, can1);
	
return var1;

END;
$$;
 �   DROP FUNCTION public.compra_cantidad_(concepto1 character varying, precio_total1 money, rfc1 character varying, cod1 integer, precio_can1 money, can1 integer, direccion character varying);
       public          postgres    false            �            1255    16633 s   compra_cantidad_x_producto(character varying, money, character varying, integer, money, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.compra_cantidad_x_producto(concepto1 character varying, precio_total1 money, rfc1 character varying, cod1 integer, precio_can1 money, can1 integer, direccion character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	var1 integer;
	fec timestamp with time zone;
BEGIN
SELECT CURRENT_TIMESTAMP INTO fec; 
INSERT INTO public.venta(concepto, precio_total, fecha_venta, rfc,direccion_de_envío)
	VALUES (concepto1, precio_total1, fec, rfc1,direccion);
	
SELECT noventa INTO var1 FROM venta WHERE precio_total=precio_total1 AND rfc=rfc1 AND fecha_venta=fec;
INSERT INTO public.consta(codigo_fk, noventa_fk, "precioXcantidad", cantidad)
	VALUES (cod1, var1, precio_can1, can1);
END;
$$;
 �   DROP FUNCTION public.compra_cantidad_x_producto(concepto1 character varying, precio_total1 money, rfc1 character varying, cod1 integer, precio_can1 money, can1 integer, direccion character varying);
       public          postgres    false            �            1255    16656 +   genera_factura_(character varying, integer)    FUNCTION     '  CREATE FUNCTION public.genera_factura_(rfc1 character varying, noventa integer) RETURNS TABLE(nombre character varying, rfc character varying, colonia character varying, calle character varying, num_interior character varying, num_exterior character varying, cp integer, numero_venta integer, precio_total money, fecha_de_venta date)
    LANGUAGE sql
    AS $$
SELECT c.nombre, c.rfc, c.colonia, c.calle, c.num_interior,c.num_exterior, c.cp, v.noventa, v.precio_total, v.fecha_venta
From cliente c, venta v
where c.rfc=rfc1 and v.noventa=noVenta;
$$;
 O   DROP FUNCTION public.genera_factura_(rfc1 character varying, noventa integer);
       public          postgres    false            �            1255    16516     venta_articulo(integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.venta_articulo(cod integer, cantidad integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	actual integer;
BEGIN
	UPDATE producto SET stock=stock-cantidad WHERE codigo=cod;
	SELECT stock INTO actual FROM producto WHERE codigo=cod;
	IF actual<1 THEN
		ROLLBACK;
		raise notice 'Hay menos de 3 en stock y no se realizo la transacción';
	ELSIF actual<3 THEN
		raise notice 'Hay menos de 3';
	ELSE
		COMMIT;
	END IF;
END;
$$;
 E   DROP PROCEDURE public.venta_articulo(cod integer, cantidad integer);
       public          postgres    false            �            1259    16517    cliente    TABLE     k  CREATE TABLE public.cliente (
    rfc character varying(13) NOT NULL,
    razon_soc character varying(100),
    cp integer NOT NULL,
    colonia character varying(30) NOT NULL,
    calle character varying(30) NOT NULL,
    nombre character varying(100) NOT NULL,
    num_exterior character varying(30) NOT NULL,
    num_interior character varying(30) NOT NULL
);
    DROP TABLE public.cliente;
       public         heap    postgres    false            �            1259    16520    consta    TABLE     �   CREATE TABLE public.consta (
    codigo_fk integer NOT NULL,
    noventa_fk integer NOT NULL,
    "precioXcantidad" money NOT NULL,
    cantidad integer NOT NULL
);
    DROP TABLE public.consta;
       public         heap    postgres    false            �            1259    16523    correo    TABLE     r   CREATE TABLE public.correo (
    rfc character varying(13) NOT NULL,
    correo character varying(30) NOT NULL
);
    DROP TABLE public.correo;
       public         heap    postgres    false            �            1259    16526    estado    TABLE     d   CREATE TABLE public.estado (
    cp integer NOT NULL,
    estado character varying(100) NOT NULL
);
    DROP TABLE public.estado;
       public         heap    postgres    false            �            1259    16637    fec    TABLE     N   CREATE TABLE public.fec (
    "current_timestamp" timestamp with time zone
);
    DROP TABLE public.fec;
       public         heap    postgres    false            �            1259    16529    producto    TABLE     �  CREATE TABLE public.producto (
    codigo integer NOT NULL,
    modelo character varying(30) NOT NULL,
    precio money NOT NULL,
    marca character varying(30) NOT NULL,
    descripcion character varying(150) NOT NULL,
    stock integer NOT NULL,
    nombre character varying(50) NOT NULL,
    imagen character varying(100) NOT NULL,
    categoria character varying(100) NOT NULL
);
    DROP TABLE public.producto;
       public         heap    postgres    false            �            1259    16532    producto_codigo_seq    SEQUENCE     �   ALTER TABLE public.producto ALTER COLUMN codigo ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.producto_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    204            �            1259    16534    provee    TABLE     x   CREATE TABLE public.provee (
    codigo integer NOT NULL,
    clave integer NOT NULL,
    fecha_compra date NOT NULL
);
    DROP TABLE public.provee;
       public         heap    postgres    false            �            1259    16537    proveedores    TABLE     Y  CREATE TABLE public.proveedores (
    clave integer NOT NULL,
    nombre character varying(100) NOT NULL,
    razon_soc character varying(50) NOT NULL,
    cp integer NOT NULL,
    colonia character varying(30) NOT NULL,
    calle character varying(30) NOT NULL,
    num_exterior character varying(30),
    num_interior character varying(30)
);
    DROP TABLE public.proveedores;
       public         heap    postgres    false            �            1259    16540    telefono_cliente    TABLE     o   CREATE TABLE public.telefono_cliente (
    rfc character varying(13) NOT NULL,
    telefono bigint NOT NULL
);
 $   DROP TABLE public.telefono_cliente;
       public         heap    postgres    false            �            1259    16543    telefono_proveedor    TABLE     e   CREATE TABLE public.telefono_proveedor (
    clave integer NOT NULL,
    telefono bigint NOT NULL
);
 &   DROP TABLE public.telefono_proveedor;
       public         heap    postgres    false            �            1259    16634    var    TABLE     �   CREATE TABLE public.var (
    cp integer,
    colonia character varying(30),
    calle character varying(30),
    num_exterior character varying(30),
    num_interior character varying(30)
);
    DROP TABLE public.var;
       public         heap    postgres    false            �            1259    16546    venta    TABLE     B  CREATE TABLE public.venta (
    noventa integer NOT NULL,
    iva_apli integer DEFAULT 16 NOT NULL,
    concepto character varying(100),
    precio_total money NOT NULL,
    fecha_venta timestamp with time zone NOT NULL,
    rfc character varying(13) NOT NULL,
    "direccion_de_envío" character varying(350) NOT NULL
);
    DROP TABLE public.venta;
       public         heap    postgres    false            �            1259    16550    venta_noventa_seq    SEQUENCE     �   ALTER TABLE public.venta ALTER COLUMN noventa ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.venta_noventa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    210            �          0    16517    cliente 
   TABLE DATA           i   COPY public.cliente (rfc, razon_soc, cp, colonia, calle, nombre, num_exterior, num_interior) FROM stdin;
    public          postgres    false    200   �X       �          0    16520    consta 
   TABLE DATA           T   COPY public.consta (codigo_fk, noventa_fk, "precioXcantidad", cantidad) FROM stdin;
    public          postgres    false    201    [       �          0    16523    correo 
   TABLE DATA           -   COPY public.correo (rfc, correo) FROM stdin;
    public          postgres    false    202   ^c                  0    16526    estado 
   TABLE DATA           ,   COPY public.estado (cp, estado) FROM stdin;
    public          postgres    false    203   /d       
          0    16637    fec 
   TABLE DATA           2   COPY public.fec ("current_timestamp") FROM stdin;
    public          postgres    false    213   Tp                 0    16529    producto 
   TABLE DATA           p   COPY public.producto (codigo, modelo, precio, marca, descripcion, stock, nombre, imagen, categoria) FROM stdin;
    public          postgres    false    204   �p                 0    16534    provee 
   TABLE DATA           =   COPY public.provee (codigo, clave, fecha_compra) FROM stdin;
    public          postgres    false    206   �v                 0    16537    proveedores 
   TABLE DATA           o   COPY public.proveedores (clave, nombre, razon_soc, cp, colonia, calle, num_exterior, num_interior) FROM stdin;
    public          postgres    false    207   w                 0    16540    telefono_cliente 
   TABLE DATA           9   COPY public.telefono_cliente (rfc, telefono) FROM stdin;
    public          postgres    false    208   �w                 0    16543    telefono_proveedor 
   TABLE DATA           =   COPY public.telefono_proveedor (clave, telefono) FROM stdin;
    public          postgres    false    209   �x       	          0    16634    var 
   TABLE DATA           M   COPY public.var (cp, colonia, calle, num_exterior, num_interior) FROM stdin;
    public          postgres    false    212   �x                 0    16546    venta 
   TABLE DATA           s   COPY public.venta (noventa, iva_apli, concepto, precio_total, fecha_venta, rfc, "direccion_de_envío") FROM stdin;
    public          postgres    false    210   vy                  0    0    producto_codigo_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.producto_codigo_seq', 21, true);
          public          postgres    false    205                       0    0    venta_noventa_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.venta_noventa_seq', 334, true);
          public          postgres    false    211            i           2606    16553    proveedores clave_pk 
   CONSTRAINT     U   ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT clave_pk PRIMARY KEY (clave);
 >   ALTER TABLE ONLY public.proveedores DROP CONSTRAINT clave_pk;
       public            postgres    false    207            n           2606    16555 "   telefono_proveedor clave_pk_telpro 
   CONSTRAINT     c   ALTER TABLE ONLY public.telefono_proveedor
    ADD CONSTRAINT clave_pk_telpro PRIMARY KEY (clave);
 L   ALTER TABLE ONLY public.telefono_proveedor DROP CONSTRAINT clave_pk_telpro;
       public            postgres    false    209            g           2606    16557    provee codigo_clave_pk_provee 
   CONSTRAINT     f   ALTER TABLE ONLY public.provee
    ADD CONSTRAINT codigo_clave_pk_provee PRIMARY KEY (codigo, clave);
 G   ALTER TABLE ONLY public.provee DROP CONSTRAINT codigo_clave_pk_provee;
       public            postgres    false    206    206            e           2606    16559    producto codigo_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT codigo_pk PRIMARY KEY (codigo);
 <   ALTER TABLE ONLY public.producto DROP CONSTRAINT codigo_pk;
       public            postgres    false    204            _           2606    16561    consta consta_pk 
   CONSTRAINT     a   ALTER TABLE ONLY public.consta
    ADD CONSTRAINT consta_pk PRIMARY KEY (codigo_fk, noventa_fk);
 :   ALTER TABLE ONLY public.consta DROP CONSTRAINT consta_pk;
       public            postgres    false    201    201            c           2606    16563    estado cp_pk 
   CONSTRAINT     J   ALTER TABLE ONLY public.estado
    ADD CONSTRAINT cp_pk PRIMARY KEY (cp);
 6   ALTER TABLE ONLY public.estado DROP CONSTRAINT cp_pk;
       public            postgres    false    203            ]           2606    16565    cliente rfc_pk 
   CONSTRAINT     M   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT rfc_pk PRIMARY KEY (rfc);
 8   ALTER TABLE ONLY public.cliente DROP CONSTRAINT rfc_pk;
       public            postgres    false    200            a           2606    16567    correo rfc_pk_correo 
   CONSTRAINT     S   ALTER TABLE ONLY public.correo
    ADD CONSTRAINT rfc_pk_correo PRIMARY KEY (rfc);
 >   ALTER TABLE ONLY public.correo DROP CONSTRAINT rfc_pk_correo;
       public            postgres    false    202            l           2606    16569    telefono_cliente rfc_pk_telcli 
   CONSTRAINT     ]   ALTER TABLE ONLY public.telefono_cliente
    ADD CONSTRAINT rfc_pk_telcli PRIMARY KEY (rfc);
 H   ALTER TABLE ONLY public.telefono_cliente DROP CONSTRAINT rfc_pk_telcli;
       public            postgres    false    208            p           2606    16571    venta venta_pk 
   CONSTRAINT     Q   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pk PRIMARY KEY (noventa);
 8   ALTER TABLE ONLY public.venta DROP CONSTRAINT venta_pk;
       public            postgres    false    210            Y           1259    16572    Informacion_basica    INDEX     G   CREATE INDEX "Informacion_basica" ON public.cliente USING btree (rfc);
 (   DROP INDEX public."Informacion_basica";
       public            postgres    false    200            Z           1259    16681    Nombre    INDEX     >   CREATE INDEX "Nombre" ON public.cliente USING btree (nombre);
    DROP INDEX public."Nombre";
       public            postgres    false    200            [           1259    16573    fki_cliente_cp_FK    INDEX     E   CREATE INDEX "fki_cliente_cp_FK" ON public.cliente USING btree (cp);
 '   DROP INDEX public."fki_cliente_cp_FK";
       public            postgres    false    200            j           1259    16574 	   fki_cp_FK    INDEX     A   CREATE INDEX "fki_cp_FK" ON public.proveedores USING btree (cp);
    DROP INDEX public."fki_cp_FK";
       public            postgres    false    207            y           2606    16575 "   telefono_proveedor clave_fk_telpro    FK CONSTRAINT     �   ALTER TABLE ONLY public.telefono_proveedor
    ADD CONSTRAINT clave_fk_telpro FOREIGN KEY (clave) REFERENCES public.proveedores(clave);
 L   ALTER TABLE ONLY public.telefono_proveedor DROP CONSTRAINT clave_fk_telpro;
       public          postgres    false    209    2921    207            u           2606    16580    provee clave_provee_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.provee
    ADD CONSTRAINT clave_provee_fk FOREIGN KEY (clave) REFERENCES public.proveedores(clave);
 @   ALTER TABLE ONLY public.provee DROP CONSTRAINT clave_provee_fk;
       public          postgres    false    206    207    2921            q           2606    16585    cliente cliente_cp_FK    FK CONSTRAINT     |   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT "cliente_cp_FK" FOREIGN KEY (cp) REFERENCES public.estado(cp) NOT VALID;
 A   ALTER TABLE ONLY public.cliente DROP CONSTRAINT "cliente_cp_FK";
       public          postgres    false    200    2915    203            r           2606    16590    consta codigo_consta_fk    FK CONSTRAINT        ALTER TABLE ONLY public.consta
    ADD CONSTRAINT codigo_consta_fk FOREIGN KEY (codigo_fk) REFERENCES public.producto(codigo);
 A   ALTER TABLE ONLY public.consta DROP CONSTRAINT codigo_consta_fk;
       public          postgres    false    2917    204    201            v           2606    16595    provee codigo_provee_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.provee
    ADD CONSTRAINT codigo_provee_fk FOREIGN KEY (codigo) REFERENCES public.producto(codigo);
 A   ALTER TABLE ONLY public.provee DROP CONSTRAINT codigo_provee_fk;
       public          postgres    false    204    2917    206            s           2606    16600    consta noventa_consta_fk    FK CONSTRAINT        ALTER TABLE ONLY public.consta
    ADD CONSTRAINT noventa_consta_fk FOREIGN KEY (noventa_fk) REFERENCES public.venta(noventa);
 B   ALTER TABLE ONLY public.consta DROP CONSTRAINT noventa_consta_fk;
       public          postgres    false    201    2928    210            w           2606    16605    proveedores proveedores_cp_FK    FK CONSTRAINT     �   ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT "proveedores_cp_FK" FOREIGN KEY (cp) REFERENCES public.estado(cp) NOT VALID;
 I   ALTER TABLE ONLY public.proveedores DROP CONSTRAINT "proveedores_cp_FK";
       public          postgres    false    203    2915    207            t           2606    16610    correo rfc_fk_correo    FK CONSTRAINT     r   ALTER TABLE ONLY public.correo
    ADD CONSTRAINT rfc_fk_correo FOREIGN KEY (rfc) REFERENCES public.cliente(rfc);
 >   ALTER TABLE ONLY public.correo DROP CONSTRAINT rfc_fk_correo;
       public          postgres    false    200    2909    202            x           2606    16615    telefono_cliente rfc_fk_telcli    FK CONSTRAINT     |   ALTER TABLE ONLY public.telefono_cliente
    ADD CONSTRAINT rfc_fk_telcli FOREIGN KEY (rfc) REFERENCES public.cliente(rfc);
 H   ALTER TABLE ONLY public.telefono_cliente DROP CONSTRAINT rfc_fk_telcli;
       public          postgres    false    2909    200    208            z           2606    16620    venta rfc_venta_fk    FK CONSTRAINT     p   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT rfc_venta_fk FOREIGN KEY (rfc) REFERENCES public.cliente(rfc);
 <   ALTER TABLE ONLY public.venta DROP CONSTRAINT rfc_venta_fk;
       public          postgres    false    200    2909    210            �   |  x�}S�r�0]�_�/� �a���I��1�3�ts#G�2u���gt�E��[~���i�3\М�ν��UG��NQ� ���U���ޕ� ��.Zs9�~U�)��F��5&���yPx�~��g�h��eY<uB�h��V�DY�B�z����۪+3�;��	=׌l��w�?\�������F3�E�x���d��CaI<q|��al�Gh8�X�c�-?��}�V��J4��JbωN\7D,�ޔ��\�`�Δ.��9	L�n�
E)�L2����!i�@a�z���y>�	���bM��M�GGP�n��U��������٘���E��t��\�l�$��}���>Hݩ���=3��/��╩�K�w�o��$���'��+�oiZ(�d~0�l(�����vj��
o�m|}d�&�'�~+��A�Seg���#F� ���+�i_��R� �E���V��Q�I�'E�M�7:g�-�7]����8q;Mg���"�ӿ�l��$�u�]aS�e�z]��?8=w�<Mx���|�8S/�x@M�c�LǸ����͓%��U�d�~nIfO��u�wr���b�E��:���6��W�@^J�?�
� ��h��>�G��otmK�      �   .  x�m��ul7���U��Y^HzI5�'U����s`��om8 !������X���_�����?ǋ��f ���5Y_+��א��ӭ��b���! d �@1O�yA�b^)��Z;f��|�dY@��L��@�,����%+�������0^�_]W �6�l4�hY�&����0^ֲ[�x��p����%������h��)��`�z���M����?�[������0�dY@ ��w�� f��	b&�� f��	b&�� f��bf��!f�1�"�=�l�5�hF�˝w�o�C��@,�рt �vc�sgr��y[������:w$����@W]t5��KG�j��	��Z�j��\���;}�����3�z�s������:�_�����Y���xl����<��LJ0)���HJ���HJ���LJ��$&��iƤ4���<��4g���Xy?��{�ot�կ9�����XcĻ��Oϧ5�K[���H|�3�qH.�线�dq����G��=6�~��=zrݺo��=����x��-�kD���o���U�)Y�A��P�(���_6�~��9�L�Ş��CG���3���2�U�c7y�]B�v4�ײ7��Ip��I0&10��IHb@�HbI�2�Q$1�$&11��ILHbB�HbI�2�Y$1�$fL�#N�~�U�*E���PeQ�Ѿy=�
�w�Q��<�͊4����\�:�녻^������5�����������n��Q�+��o���w�pWV�_s���V�n���p'�;)�	�Sp��;-�)�3pg�;+��XR�
)W�������O��x�>�:!V�0�ri�e+mGi�5*mgi�)mWi��'��R�b���my�+1����H�nT�*V�v���-6MźҲ��J����+źR�+-�J���J˺R�+źҲ��J����+źR�+-�J���J˺R�+k��n�]ͤ9w
k��㮞ev�7p�$��6"0#0#4c0c0c4�۬�{�Fp�,����6�H��D[(�Lm��B;�5M�N��GS�S��}��,�Q��!������!����U��<���YZ%E>&�� ��0
*��"
��+������t�v���5��(|�5��D_��5��_}���B_ym�#�$���h>�d��硱yR���Q->��G�nh�(t{G�-t{�-u�L����������=N�&ͳ�Ͻ�8�ͅ�2���6����Y�Y��h4
���8�Y��9�+QY�d2�d�j�i���!1M���<$��.0��o7��Nq�3h�!�3[�C�I:���%aմä=v�y\H7�����]�d�{�+C/�Y�weg�Qz	�7�MT6DH�Iab&Fab&^�d
����g��j1�
;T�A��:�;W뜡�r�]�Q���)��C8w�D�E�\K������p�����l��YL2�vI^^���,/����:, .�@��@7X^�W�k����@^^\]lMˋ'L��	�8��-N�j�*v=Lf�m�%�z�G88�xFp��A53h&h�h��+�#A��"�E�Y,�=���<�z�94L�[�ºz�9����^o}Z%��8�bu��+N���7����z�����LV�=pǶz��W�RIQ��Xh�ܢ���C�𮛅.?:�n����:)tyv��|�p��|m��5��Ӵ�z��GE�b�&i�*�Å����
63��L�L+�i�d�\.$?�,����iV�4�4ޓDa��(n痐(3�i��K��:�z!#�Q��U�q�� �"@�e�^5�t b6�� f��b6��r��r��r��r��r������]�.y�v�i�V:�pz��M�e��!�t �� �1w��C�1S�y4��X���e2�w\��N
Y�~3^�]�~��Z���}�_#��o��A�E4��ٲ�Y��R�{�F��kwIG!~���8�o��CtQ��s���G�-FKW,w�_���=I�g�G:�ח#��Q��Bǅ��:��uh6󿿿����m��      �   �   x�]��
�0E��c���؝:@�
�]��g�c
��NPT��p�y�v�n|�	G:h��K��\���EUWM����CLpk����޾�P�sJ�K0^�Qxf�%��<��ecw�>t�&���Cb���D��4Q�m��U/�g	�\De��"K2�q|�A�]�knʇԳl��� W���Z0�̸ؖe� }j�            x�u�=�q�X�:���'cž��O�"G|%�CSO�UZX�rz��ꞩn���/�����_�����?���������?گ��Gx����1|�|�usL����P��;�m�/��6G�9���I����uwǤ��o���o�/_�1�ۿv����g�����1\���w����|^�㵇���#~���r8��¾��;������rzO����O���9������_��2�-���].�����^�k�"�$ˁ]���l�T��W�xo�{;����ۛm�1l?����I>َ������<^�����9����$p�!�O��I;f��q�kR���u�Cu��s�W�^G��A؁}���M�݂�[�v�ne�-A�%h�햠�Z�`�[�v�ʂu ���O�Ee�����2�[�uK�n)W�0�'o!�-D��H�KK�n�Э
��_N��nUЭ
�UA�*�V}1�t����ߝ��Tw��NG};&�1َ�sZw�*�1qN�N^�Y�;u���tԝw��Nw���$ݙ�;	t�}7���<�y��|���_X�����,5����T�J�ù���k��a�&�a�f䂹�0Q�0Q3�0#3�p�6L�ì9\4��0k�AÅ�pa37�X����0W0�5�0���0���0��0Q�p�1L��d:�և�t���q���q���j����j�<-��)lZ�Ns�t�q�¦)lZkN��	o��
�,�&�i&�ieZ�����9Hs�
�9v�c�9v�L�{aӪwZ�N�ނ��iZ���i�<M��d:M��d:M��d:M��d:M��d:͚3&f�i�,X��ie:M����C������4#�3��O���׾��k���Ce�<���5�F^N0�	f9�,'���r�Y~WW�"X�"�����-��k����圶�Ӗ���˭�[�/��S�rN[�ik����Ӗ�W��g��,����j}�֗i}�֗9v�c�9v����BX�l���s�}.�����>�����v�u�úM������ۧx��n��m��} ������iخt�Uض��>;ۧa{�od�y��li�]ym��}}��nmK�}��5]�m����z|\����<>�����k�b��S||��?�9>�Ǉ��S�����ߓG���k;�~�R�������Օ+X/�
�o~:-<*�c2-�+�~���f�L���~�� ��������7���p���q�8��8�+�c�w�����Y�`ގ��q��X&�8��L<nf����qv-X�n��,�#R0c��}�(9N��_wD���t>nt7���Ǎ��F��>9�w[��-�ݖ�7��o$��R��G|s���ˉ��q����(�dz������v�㷝�z��t,�[M3����<֚�ڦG+ӂ�kւ�`_$��y����sv�9;���";��{aǽ��}m��9s�sv�v�����+�����@���R�Z�]��k�u���e˵l��-���:�_'��x�`��A�y�:�\����u�N׌|���{ͱ�dzM���qM�TpM�g���<����|v������.~�������
�O�s��\�>ח�TP�h���{&�g�x&��:�O���&�sA�\y=W^��La�v�l�%�s��\b=��su�̚�/]4�}�Z깖z���ˠ��@?K'��$�\=�A���s��\��:~͘8K=WG�T)��G�������s��\b��q��K�:E��`UG�/]��۱*xVϪ�|��5D�^�����b�Y�<���׀3���f�S0O���B�Y)=�8��˂��\v>���eg���������`F�2�Y&>��d�K���|�K��ur]'�up��Y�g�Qx�u�����ڣ����3n��[��co��=�ϯn<�&�0~������|����3�Ϲ���<�'��~�����_p���%��`?������x�¹K�
� �p��>�ޓ�=Yܓ�=�ٓo=�˓�<��[���O���O��x��i�7�E<����;�����������������kK��dO�� /����������'Wv�e'_vr`'�t�I'�o��&�or�&�o�lɾ���-�p<ܬ�
�:?�mV�ܳ��i%i�I�)x/�B[0��`�l�4قW�w_��\u-��Z�յ`�k��ւ���[�ajH��#�a���j�}5¼���w/\5����*�~�%4���f��_�i��yo=܃��u}R��F茠g�?�'�s�p��;���Ao�bN��C���(y�8�91��؂��c���s	�_�O�3cn��=�+�[04��Ql�yׂ���]�����&����3���:�����&��aXS�������3LR��:��G㇇߇�
<<�D�������P��z�p���ǐ��[�l����"89?<�����ق������=�,ڂ-���:=�-�H?<\��x���f�jN��z���i�
�����k�<�o�'~w���:a_���i$]�I7������-Xt[����p��/;[0�����p��N(���p�sO�З(<\?��拡��&���3����7��a�p�ߟ���	y���������-Xd[p���A-<x��"�P��NV���_��x��{�c����ڂ�����C|B��o�f�CBf�������BY��\!���G�;���4�4�&M�FC	������_��W����-�Rx�'������q�a�a��
����+��W�{���^��B�{���J���
O�	�şy�`�n��݂E��=A6�
g߲pO����=�6��;������o�8ނs��xn���s	�h���C��!��w�������
�H����i}|�N]�=#�Gz����h-<�'�����}��Л�~���v=[��ꝝ�Q���>y�a=-�'�9�S;ͶNíC^C
�~�!����wȃ;L�.�q#����p�����C�-��9��0:���	-LIha���?��7y<&      
   *   x�3202�50�54P02�22�21ӳ02�0��q��qqq w�P         V  x��W�r�F����Ҟ�`��'�hqŔ���I�4G�D����!]�MTf&*2���M�$�� 	HΤH�v������3�>U"�N4�������s�59��S-��Q���цʦ�%�<��.�
j
�y�~m8%�����S)^�pF����+I���ε��9�F�� 9�ê���;��%�����(>��x��-��3��1ū���V�WB,s�h0ط��oX�U!5�������=��{��*�	����:zs|�m�i�yk\�Cy�(�F���/�d�-ՍB*�M/��9�R�/�zsQ$Y��T���س�V�[�	[/��G�5��h��<���g�3+��iQ<�Y�l O��+�k��u"�H�٥X���ׂ�g�g��������E��Sߋ�k��Kh�$4��|��E��kB�D��A��R@�n��%<=*YU�,c���`Q�QyCKB��rz��9@���tX�v� }2�F�.��WwW?u�N~F���p��i�JŢy�=��+��]��g�H��UKF�%�i��}$a�HYj`�K=JtQ�]UdV	�T5�k
"�y���Ò��Pi�U�l7�FƖ������L�y�[D����y�m&O3fOK�m�����L���I7�x0ٕ�����J 噵\l2���W ��vZ�Z�#�`P)+��)?jQZoL���A�`�@�}G��(�(�W�k�kL�	:���D�� �2�"�?�'�+I����#���Y���S�ɑ���"�N�>W��L�JL�^׬dT��U	���u]JT�҅�����Y#���Ğ7Y���v6�t��a�;��Q0�ǶX�J���Q�J�����<E����߹y]>�fFF�^�1�������^�f�ӳ��1�@ �̅�W�傛1��/��׌K-T�1��:G󖻷�L��`�G���s�p+p>�8�8���}��Чx���Y�'�N�ݨ��d����rzs���ι�F�'²�nx�[bZ<�c�U}M'�%Dw �)&���	�:�w9�*�`���p�C������r�q�l	Gn�}FҴ<^�hp���8j�M�l�ҽз��1˴c�
5��T.�1%�O�Hѿ4�d��O�Z(=d (�c%����}��K�s�Nu'lN�uj!Q�u�rf&d��b�[ʬ���%��Ԃ0b&�� �׏����A�໺
v�w'n8��a�tα���b3e�l�@�$�ۧ�@���ZT�D􄵙�x.wL��C�/$�f"���.�L[;aw��=�KY����P��-B�>Wl	�SdfG{��J��ރ�`�A~nzH�x�[O�q/�q��\�W�E�M��3C�`����@G`��]�Ӎ:m�Z{��� ��vGf�Æ,
S�Δջ��cP��л�H93L���U�P8h�k�}��m�~���V#�X�m�vZ%p����������{N^o��,�ț�9i�f`k�Y2c���0p�WsjH�
<}h��Z�z�}.8��J��*�rU�X�0R�k�����R{�SKAw��߂m
����ٔN*��d��a��� ��j��L>S�a�*iN�sah��dj������ ��            x������ � �         �   x�u��NA��ݧ�' ;�rd7� !1�x�R�b��Nu����[�#{l�~��mV��v��C��c�d�F��s@�wsWCK������^�#8p�m��}�w��]]�?�I�Sf��"�ke����m{a��EF�4z>J|]��+�
O�+����BI��_�3�݉�,�	u������c���kl�T��m�9u9#��b֧]��YUU��Rl         �   x�U��
�@E��c�$�L�z��VPw���vY��N���Y�=i�Ǯ4D�B�;O�0��}�4�	��IK��̯5y��;O�X�|��#KP�M�p�A�
��E�@<����{��K���V���$�`�%U�|�Blд����Z���<=9A            x������ � �      	   �   x�U�A
�0 ϛW�b���(^존�zYt���+�����k�S!�a�a7/��4���@�G�=Ck��
{�\hd9������<�b���\]ͳu���	w\�#�0X�Zx"��>�Ic�E
U��B�.�������]+��K�5]&;@V���!(���q��X=���[@�         �  x���Ϯ�7���'W�%�ᕽ����g�4@Q�5DB�I�Z�6���cn�+�����Jx�_���HH� ��_�Y���&�ۻ���x�곻��ݛgo����i���ǿo(P�y�?r���Ly+�$)?�����/�����?��ݷ_�x��$%þ���_~x���njz���D���dKAjý���?��_}s����=Ir�"�7IE*]���(O���c�
E������������o���7}�$Ն�%nY�E위ulZKH��9aA�J�)H�P9'�(�u��@�A����E7Ѭ�|�A���dgE� �Δ6RpΑC���4����Z�;�r7ř��At-�+@��:�k�s�p��Q>�k�$o��,���3��C�q: k)g���d���eM�T<�E�-"o��
���1n��1��cMu�Ɯ�R�3H�� 2W��c�\�� ��MKR���G!F�e��K8 B(L���R�x $-��Jފ� ���n�!���������#�0��r@�1�X]j.��/�m �"�q�%;�-�Т�*^��R``5���.�Mr�`���r��D��bTCe~�5��-���m݅}�+�d�GU-e�Q��8g޲��ܮjW1oQf�z�N���㋯~���u������I�BN�q��{�s�J�V?�����)��'�5�m+nqr$m�Ǳ�9;yp�KF�x��ªK�J��CÁM!��B��j<R��Ĺ�R: ;��5��i( ���`�sPr�����5��3�b_L���V�wF�"���N�k"���vQ��O��:{�k�q.0hB�5?���X�VZ�������c&��Y��h�E���̏i�*B\�1�78���!�	E��P��1>hd<�xg!K#�������J�ܜ��^��RbXS���e���iΎS�K�	���O�%{^P�!l��
&��� ���m��s.�`��ļ`�JA��,mBY�K�H�}O]P�1�Ƭ�-�
��4T�9��区wC�ԑ?-�o���e�(�U�p�%ygD�&;&T��|lBY7�UM�˞�L �b9=Wq?h!�� 㯪�[�B�� '����e!�T-FפJ�o��t�Z�/����/�+�{�C�&��-gcƟ9��t�(cw�M��x!]�c"{�猸�8H�ʄ#�6�S�E�%GwG�i�FΗ��{Dv���(Z5ϳx�!�lAT��Q�z��h^D�C����M���Y3�:��g�S\�Ĝq@�-����r�^�%�]Ӛ�,�դ��E+^#+�+��Ҋd>)ņ�)䤟I�P9%x_��S>@�֩K EoM� 	�В54RW����I�5F���Ĵ˻�-����B��,�2�y�+�����	T��rGR���[�
U#K��k��1���f�G�D�����A����p�v�T)���2.�)`� �ΈX~2�'�	9��(�N�6��Ԛ��d����w�q��Cr���-
�$�٫!d���l�0
e���\�~�Xi����<}�y��tI�О	���a|��S�;�Gh�(�#��(�O�<N+`K���Pb��!�\��I\�4�S--C:����|L�j,�[O]r�$ɳ&������H*�ˁ�R�R[�C�,��r�淹4�Q&��0�*�����)����f�U{~��j�����up��W38	^�Q�"�u���j6Yf�\����a��T#�m�/f��Xp�U���b�9�Vk�T��k��l5�$���K5�:�i�&g��R�V�֍��W�Յ���p�6)��ݺ�sk #w�=_Xjn�x���%�u��]��~=�Bα���
���<u!�خ�A�Y�:��.�[�BGJ�X��QJ����1;I�d��"Z�#4�p2�&�:�ky�\�14�ɴjS�Ԓ��?׬�B���q�s�M����ߒ�8���q��F�6�o0�����Ǧ7��֦�����,9d��6��z�.�_�~N0�x�v��`SF�2�P�.@\8(^U��w)�� L�L��MH@�����wGh�E���Lh��m?Q'B����`i	c+ĵd��09 C���`y	˜PP塾`���<�Fu��`7�.aق ʓ2��خ|��=�`��fDp�2*�1,^�,�
�FnU!�{~|I|��V����X7��@�Z-PlW�	�_ԮBZ���&/8���8v�\��36<v�X�®LWx��i�*�,ye}j��%ބX�է�.moħ2��h�6W\����8��d��FI��@�PӃ�(�:�>��`l!����G��bea�?1���0��2�>�D"xeس��^>��4��L��Z��*.��x��
��,~�,sڳD��Q{�|�{ۣ�},�y�J�WP�a6��k��V�# �p�q����ciU�tt}^:�t9���75��Ni��@�J�6�����_�|���&|�vT���q)e�I�Q����D���dl�
�bY�1j��3��m�����s�{�~{����#L��5����f�A�-�z��l~�Yw��bG޻/�e�%(Z0�uu���d�@�T����ґww�6������#q��}P�Q!jE��Z�=�#ի.��b�	�B�W��wu��i��� 3>{\���4Y�ĞN!G!�?]:ኇ����k��v��$z��QjAdA�=�K���A�t*rه�Wˏ��HRv��O=Pi9��]����/H��426n:���4�:��L}X�&c�C�s���B'��,��݀�<Wa�OH���Ȓ�%�߾K�4����d��2�@@�ڻ�*ȮW�w��pJ"���~��#�{�x5�7�=`�i��fZ²��.F,��/%��h��+��������5��E���iqh�(Y��EudҤ+E�9���(d��G�.��I�	|���Q��ef�J�(��%���1��T��9E��:�>VuQd3���ɻ�a���vV)l�5M�42���_�'�4�������Q�i����0�h���Nk�BP�����݁��	
RĎa0=к�ӵ��^=���K�CX����P$%����(֣�린�Z�.�d]�'𖣮��ǲl! ���~����Hmh����l��%L�/O��_z�>��`�� ]��k0DLdÅ�V���2E�t}l��������y�٭k�s$Z�{��0�2*��F��:�d�Z�í-a�������t�]��R�iD~^U��$����r����ti�6E�,��.-@ڴTC�ˎ�.- 0�ը�̱ui bJ��nZ��� ������0K�k�y�Ay�}�4 )�}(ه�`K���<HNj]K�j�(%��3��VLb���'�n?|���oޝ����;�.�㯫t���ܥ�0�9�}�{�?�81X�M6^xزx��z��؞���Q���n�b�$BF��C�.(�SBL��Z.�F
қ�6$q(]���\� G"�X?i�޽|��%�J�d��쯀-�C���F�ti��V�Ǥy�U.@�ˈ���%���-1Ŝ�|�+��nŵlp)=\�+��WK�ܩ�芳ؓ��Iؓ8��,���8�z)qAɶ��59��OM�����N���۲�<����Ojف	��:�S���i/�=�!>'�^�s���$kB�O���� _�e�W:�;��]�Zr����=O4Q ����h~�I��b��h�]���3ЈPfV��֤C��!���m�~�5�HH�S���se��������#�`�<���e�Y�e�o_�E �$������g��OO�w/��ǿ�x������ˏ����w�϶_nOO�=��W�n?���W�_<��o�N�y���_<�=�n{���k�V���
��R�~���?�*e<Ui?4`OՐ�]~.��kD,蓄�����o��������������n��a{��� �#m�     