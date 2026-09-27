IDENTIFICATION DIVISION.
PROGRAM-ID. LeerContactos.

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
01  W-Fin               PIC X VALUE 'N'.

PROCEDURE DIVISION.
Principal.
    OPEN INPUT ContactosFILE
    IF W-Status NOT = "00"
        DISPLAY "Error al abrir el archivo o no existe. Status: " W-Status
        STOP RUN
    END-IF.

    DISPLAY "--- LISTA DE CONTACTOS GUARDADOS ---"
    
    PERFORM UNTIL W-Fin = 'S'
        READ ContactosFILE NEXT RECORD
            AT END
                MOVE 'S' TO W-Fin
            NOT AT END
                DISPLAY "ID: " Con-Id " | Nombre: " Con-Nombre
        END-READ
    END-PERFORM.

    CLOSE ContactosFILE.
    STOP RUN.