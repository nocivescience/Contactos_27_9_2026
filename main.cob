IDENTIFICATION DIVISION.
PROGRAM-ID. GuardarNombreDB.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT ContactosFILE ASSIGN TO "contactos.dat"
        ORGANIZATION IS INDEXED
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS Con-Id
        FILE STATUS IS W-Status.

DATA DIVISION.
FILE SECTION.
FD  ContactosFILE.
01  Contacto-Reg.
    05  Con-Id          PIC 9(4).
    05  Con-Nombre      PIC X(30).

WORKING-STORAGE SECTION.
01  W-Status            PIC XX.
01  W-Nombre-Input      PIC X(30).
01  W-Ultimo-Id         PIC 9(4) VALUE 0.
01  W-EOF               PIC X VALUE 'N'.

PROCEDURE DIVISION.
Principal-Logica.
    *> 1. Abrir o crear el archivo si no existe
    OPEN I-O ContactosFILE
    IF W-Status NOT = "00"
        OPEN OUTPUT ContactosFILE
        CLOSE ContactosFILE
        OPEN I-O ContactosFILE
    END-IF.

    *> 2. Buscar el ID más alto actual para autoincrementar
    MOVE 0 TO W-Ultimo-Id.
    MOVE 'N' TO W-EOF.

    START ContactosFILE KEY NOT < Con-Id 
        INVALID KEY MOVE 'S' TO W-EOF
    END-START.

    PERFORM UNTIL W-EOF = 'S'
        READ ContactosFILE NEXT RECORD
            AT END
                MOVE 'S' TO W-EOF
            NOT AT END
                IF Con-Id > W-Ultimo-Id
                    MOVE Con-Id TO W-Ultimo-Id
                END-IF
        END-READ
    END-PERFORM.

    *> Sumamos 1 al último ID encontrado (si está vacío será 0 + 1 = 1)
    ADD 1 TO W-Ultimo-Id GIVING Con-Id.

    *> 3. Interfaz con el usuario
    DISPLAY "=================================="
    DISPLAY "   REGISTRO DE NOMBRES EN COBOL   "
    DISPLAY "=================================="
    DISPLAY "ID asignado: " Con-Id
    DISPLAY "Ingrese su nombre: "
    ACCEPT W-Nombre-Input.

    MOVE W-Nombre-Input TO Con-Nombre.

    *> 4. Guardar el nuevo registro
    WRITE Contacto-Reg
        INVALID KEY
            DISPLAY "Error: El ID ya existe."
        NOT INVALID KEY
            DISPLAY "¡Nombre guardado con exito!"
    END-WRITE.

    CLOSE ContactosFILE.
    DISPLAY "Programa finalizado."
    STOP RUN.