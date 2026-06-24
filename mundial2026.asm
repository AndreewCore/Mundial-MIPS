# ============================================================
#  SIMULADOR FASE DE GRUPOS - MUNDIAL FIFA 2026
#  Materia: Organización de Computadores - CCPG1049
#  Lenguaje: MIPS Assembly (Mipsy Web)
# ============================================================

.data

# ==================== NOMBRES DE LOS 48 PAISES ====================
# --- GRUPO A ---
pais0:  .asciiz "Mexico"
pais1:  .asciiz "Sudafrica"
pais2:  .asciiz "Corea"
pais3:  .asciiz "Republica Checa"

# --- GRUPO B ---
pais4:  .asciiz "Canada"
pais5:  .asciiz "Bosnia"
pais6:  .asciiz "Qatar"
pais7:  .asciiz "Suiza"

# --- GRUPO C ---
pais8:  .asciiz "Brasil"
pais9:  .asciiz "Marruecos"
pais10: .asciiz "Haiti"
pais11: .asciiz "Escocia"

# --- GRUPO D ---
pais12: .asciiz "USA"
pais13: .asciiz "Paraguay"
pais14: .asciiz "Australia"
pais15: .asciiz "Turquia"

# --- GRUPO E ---
pais16: .asciiz "Alemania"
pais17: .asciiz "Curazao"
pais18: .asciiz "Costa de Marfil"
pais19: .asciiz "Ecuador"

# --- GRUPO F ---
pais20: .asciiz "Paises Bajos"
pais21: .asciiz "Japon"
pais22: .asciiz "Suecia"
pais23: .asciiz "Tunez"

# --- GRUPO G ---
pais24: .asciiz "Belgica"
pais25: .asciiz "Egipto"
pais26: .asciiz "Iran"
pais27: .asciiz "Nueva Zelanda"

# --- GRUPO H ---
pais28: .asciiz "Espana"
pais29: .asciiz "Cabo Verde"
pais30: .asciiz "Arabia Saudita"
pais31: .asciiz "Uruguay"

# --- GRUPO I ---
pais32: .asciiz "Francia"
pais33: .asciiz "Senegal"
pais34: .asciiz "Bolivia"
pais35: .asciiz "Noruega"

# --- GRUPO J ---
pais36: .asciiz "Argentina"
pais37: .asciiz "Argelia"
pais38: .asciiz "Austria"
pais39: .asciiz "Jordania"

# --- GRUPO K ---
pais40: .asciiz "Portugal"
pais41: .asciiz "Jamaica"
pais42: .asciiz "Uzbekistan"
pais43: .asciiz "Colombia"

# --- GRUPO L ---
pais44: .asciiz "Inglaterra"
pais45: .asciiz "Croacia"
pais46: .asciiz "Ghana"
pais47: .asciiz "Panama"

# Tabla de punteros a los nombres de paises (48 entradas)
pais_ptrs:
    .word pais0,  pais1,  pais2,  pais3,  pais4,  pais5,  pais6,  pais7
    .word pais8,  pais9,  pais10, pais11, pais12, pais13, pais14, pais15
    .word pais16, pais17, pais18, pais19, pais20, pais21, pais22, pais23
    .word pais24, pais25, pais26, pais27, pais28, pais29, pais30, pais31
    .word pais32, pais33, pais34, pais35, pais36, pais37, pais38, pais39
    .word pais40, pais41, pais42, pais43, pais44, pais45, pais46, pais47

# ==================== ARREGLOS PARALELOS DEL GRUPO ====================
# Indices de los 4 paises seleccionados (0-47)
seleccion: .word 0, 0, 0, 0
# Goles a favor
gf:        .word 0, 0, 0, 0
# Goles en contra
gc:        .word 0, 0, 0, 0
# Puntos
pts:       .word 0, 0, 0, 0

# ==================== SEMILLA PARA NUMEROS ALEATORIOS ====================
seed: .word 31415

# ==================== MENSAJES ====================
msg_titulo:    .asciiz "\n============================================\n"
msg_mundial:   .asciiz "    SIMULADOR MUNDIAL FIFA 2026\n"
msg_sep:       .asciiz "============================================\n"
msg_lista:     .asciiz "\n--- PAISES PARTICIPANTES EN EL MUNDIAL 2026 ---\n"
msg_punto:     .asciiz ". "
msg_nl:        .asciiz "\n"
msg_tab:       .asciiz "\t"

msg_sel_titulo:.asciiz "\n--- FASE 0: SELECCION DEL GRUPO ---\n"
msg_ingrese:   .asciiz "Ingrese el numero del pais "
msg_ingrese2:  .asciiz " (1-48): "
msg_err_rango: .asciiz "  Error: numero fuera de rango. Ingrese un valor entre 1 y 48.\n"
msg_err_dup:   .asciiz "  Error: ese pais ya fue seleccionado. Elija otro.\n"

msg_grupo:     .asciiz "\nGrupo formado:\n"
msg_guion_pos: .asciiz ") "

msg_partidos:  .asciiz "\n--- FASE 1: PARTIDOS ---\n"
msg_partido:   .asciiz "\nPartido "
msg_dos_ptos:  .asciiz ": "
msg_vs:        .asciiz " vs "
msg_resultado: .asciiz "  Resultado: "
msg_guion:     .asciiz " - "

msg_tabla_sin: .asciiz "\n--- TABLA DE POSICIONES (SIN ORDENAR) ---\n"
msg_tabla_ord: .asciiz "\n--- TABLA DE POSICIONES (ORDENADA) ---\n"
msg_encabez:   .asciiz "Pos  Pais              PJ  GF  GC  DG  PTS\n"
msg_sep_tab:   .asciiz "-------------------------------------------\n"
msg_espacio2:  .asciiz "  "
msg_espacio4:  .asciiz "    "

msg_clasif:    .asciiz "\n--- FASE 3: CLASIFICADOS ---\n"
msg_clasif2:   .asciiz "Los equipos clasificados a la siguiente etapa son:\n"
msg_1ro:       .asciiz "  1ro: "
msg_2do:       .asciiz "  2do: "
msg_fin:       .asciiz "\n============================================\n"
msg_fin2:      .asciiz "        FIN DE LA SIMULACION\n"

.text

# ============================================================
#  MAIN - Punto de entrada, coordina todas las fases
# ============================================================
main:
    # Bienvenida
    li   $v0, 4
    la   $a0, msg_titulo
    syscall
    li   $v0, 4
    la   $a0, msg_mundial
    syscall
    li   $v0, 4
    la   $a0, msg_sep
    syscall

    # FASE 0 - Mostrar lista y seleccionar grupo
    jal  mostrar_lista_paises
    jal  seleccionar_grupo

    # Confirmar grupo
    li   $v0, 4
    la   $a0, msg_grupo
    syscall

    li   $s0, 0                        # i = 0
mostrar_grupo_loop:
    beq  $s0, 4, fin_mostrar_grupo
    li   $v0, 1
    addi $a0, $s0, 1
    syscall
    li   $v0, 4
    la   $a0, msg_guion_pos
    syscall
    la   $t0, seleccion
    sll  $t1, $s0, 2
    add  $t0, $t0, $t1
    lw   $a0, 0($t0)
    jal  imprimir_nombre_pais
    li   $v0, 4
    la   $a0, msg_nl
    syscall
    addi $s0, $s0, 1
    j    mostrar_grupo_loop
fin_mostrar_grupo:

    # FASE 1 - Simular partidos
    li   $v0, 4
    la   $a0, msg_partidos
    syscall
    jal  simular_partidos

    # Mostrar tabla sin ordenar
    li   $v0, 4
    la   $a0, msg_tabla_sin
    syscall
    jal  mostrar_tabla

    # FASE 2 - Ordenar tabla
    jal  bubble_sort

    # Mostrar tabla ordenada
    li   $v0, 4
    la   $a0, msg_tabla_ord
    syscall
    jal  mostrar_tabla

    # FASE 3 - Clasificados (primeros 2 del arreglo ya ordenado)
    li   $v0, 4
    la   $a0, msg_clasif
    syscall
    li   $v0, 4
    la   $a0, msg_clasif2
    syscall

    li   $v0, 4
    la   $a0, msg_1ro
    syscall
    la   $t0, seleccion
    lw   $a0, 0($t0)
    jal  imprimir_nombre_pais
    li   $v0, 4
    la   $a0, msg_nl
    syscall

    li   $v0, 4
    la   $a0, msg_2do
    syscall
    la   $t0, seleccion
    lw   $a0, 4($t0)
    jal  imprimir_nombre_pais
    li   $v0, 4
    la   $a0, msg_nl
    syscall

    li   $v0, 4
    la   $a0, msg_fin
    syscall
    li   $v0, 4
    la   $a0, msg_fin2
    syscall
    li   $v0, 4
    la   $a0, msg_fin
    syscall

    li   $v0, 10
    syscall


# ============================================================
#  mostrar_lista_paises
#  Muestra los 48 paises numerados del 1 al 48
#  Modifica: ningún $s (los guarda en pila)
# ============================================================
mostrar_lista_paises:
    addiu $sp, $sp, -8
    sw    $ra, 0($sp)
    sw    $s0, 4($sp)

    li   $v0, 4
    la   $a0, msg_lista
    syscall

    li   $s0, 0                        # i = 0
loop_lista:
    beq  $s0, 48, fin_lista
    li   $v0, 1
    addi $a0, $s0, 1                   # imprime i+1
    syscall
    li   $v0, 4
    la   $a0, msg_punto
    syscall
    move $a0, $s0
    jal  imprimir_nombre_pais
    li   $v0, 4
    la   $a0, msg_nl
    syscall
    addi $s0, $s0, 1
    j    loop_lista
fin_lista:
    lw   $s0, 4($sp)
    lw   $ra, 0($sp)
    addiu $sp, $sp, 8
    jr   $ra


# ============================================================
#  imprimir_nombre_pais
#  $a0 = indice del pais (0-47)
#  Imprime el nombre del pais en pantalla
#  Funcion hoja (no llama a otras funciones)
# ============================================================
imprimir_nombre_pais:
    la   $t0, pais_ptrs
    sll  $t1, $a0, 2
    add  $t0, $t0, $t1
    lw   $a0, 0($t0)
    li   $v0, 4
    syscall
    jr   $ra


# ============================================================
#  seleccionar_grupo
#  Solicita al usuario 4 paises con validacion
#  - Rango: 1-48
#  - Sin repetidos
# ============================================================
seleccionar_grupo:
    addiu $sp, $sp, -12
    sw    $ra, 0($sp)
    sw    $s0, 4($sp)                  # contador de seleccionados
    sw    $s1, 8($sp)                  # indice del pais elegido (0-47)

    li   $v0, 4
    la   $a0, msg_sel_titulo
    syscall

    li   $s0, 0                        # i = 0 (cuantos llevamos)
loop_selec:
    beq  $s0, 4, fin_selec

    # Pedir numero al usuario
    li   $v0, 4
    la   $a0, msg_ingrese
    syscall
    li   $v0, 1
    addi $a0, $s0, 1
    syscall
    li   $v0, 4
    la   $a0, msg_ingrese2
    syscall

    li   $v0, 5
    syscall
    move $t0, $v0                      # numero ingresado

    # Validar rango [1, 48]
    li   $t1, 1
    slt  $t2, $t0, $t1                 # t2 = 1 si t0 < 1
    bne  $t2, $zero, err_rango
    li   $t1, 48
    slt  $t2, $t1, $t0                 # t2 = 1 si t0 > 48
    bne  $t2, $zero, err_rango

    # Convertir a indice 0-basado
    addi $s1, $t0, -1

    # Verificar si ya fue seleccionado
    move $a0, $s1
    move $a1, $s0
    jal  ya_seleccionado
    bne  $v0, $zero, err_dup

    # Guardar en arreglo seleccion
    la   $t0, seleccion
    sll  $t1, $s0, 2
    add  $t0, $t0, $t1
    sw   $s1, 0($t0)

    addi $s0, $s0, 1
    j    loop_selec

err_rango:
    li   $v0, 4
    la   $a0, msg_err_rango
    syscall
    j    loop_selec

err_dup:
    li   $v0, 4
    la   $a0, msg_err_dup
    syscall
    j    loop_selec

fin_selec:
    lw   $s1, 8($sp)
    lw   $s0, 4($sp)
    lw   $ra, 0($sp)
    addiu $sp, $sp, 12
    jr   $ra


# ============================================================
#  ya_seleccionado
#  $a0 = indice del pais a verificar
#  $a1 = cuantos paises ya fueron seleccionados
#  Retorna $v0 = 1 si ya esta, 0 si no
#  Funcion hoja
# ============================================================
ya_seleccionado:
    li   $t0, 0                        # j = 0
    la   $t1, seleccion
loop_ya:
    beq  $t0, $a1, no_dup
    sll  $t2, $t0, 2
    add  $t2, $t1, $t2
    lw   $t3, 0($t2)
    beq  $t3, $a0, si_dup
    addi $t0, $t0, 1
    j    loop_ya
no_dup:
    li   $v0, 0
    jr   $ra
si_dup:
    li   $v0, 1
    jr   $ra


# ============================================================
#  rand_lcg
#  Generador congruencial lineal
#  seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF
#  Retorna numero pseudoaleatorio en $v0
#  Funcion hoja
# ============================================================
rand_lcg:
    lw   $t0, seed
    li   $t1, 1103515245
    mult $t0, $t1
    mflo $t0
    addiu $t0, $t0, 12345
    li   $t1, 0x7fffffff
    and  $t0, $t0, $t1
    sw   $t0, seed
    move $v0, $t0
    jr   $ra


# ============================================================
#  rand_0_5
#  Retorna numero aleatorio entre 0 y 5 en $v0
# ============================================================
rand_0_5:
    addiu $sp, $sp, -4
    sw    $ra, 0($sp)
    jal  rand_lcg
    li   $t0, 6
    divu $v0, $t0
    mfhi $v0
    lw   $ra, 0($sp)
    addiu $sp, $sp, 4
    jr   $ra


# ============================================================
#  simular_partidos
#  Inicializa estadisticas y genera los 6 partidos (todos vs todos)
#  Partidos: (0,1) (0,2) (0,3) (1,2) (1,3) (2,3)
# ============================================================
simular_partidos:
    addiu $sp, $sp, -4
    sw    $ra, 0($sp)

    # Inicializar GF, GC, PTS a cero
    la   $t0, gf
    sw   $zero, 0($t0)
    sw   $zero, 4($t0)
    sw   $zero, 8($t0)
    sw   $zero, 12($t0)
    la   $t0, gc
    sw   $zero, 0($t0)
    sw   $zero, 4($t0)
    sw   $zero, 8($t0)
    sw   $zero, 12($t0)
    la   $t0, pts
    sw   $zero, 0($t0)
    sw   $zero, 4($t0)
    sw   $zero, 8($t0)
    sw   $zero, 12($t0)

    # Partido 1: posicion 0 vs posicion 1
    li   $a0, 1
    li   $a2, 0
    li   $a3, 1
    jal  simular_un_partido

    # Partido 2: posicion 0 vs posicion 2
    li   $a0, 2
    li   $a2, 0
    li   $a3, 2
    jal  simular_un_partido

    # Partido 3: posicion 0 vs posicion 3
    li   $a0, 3
    li   $a2, 0
    li   $a3, 3
    jal  simular_un_partido

    # Partido 4: posicion 1 vs posicion 2
    li   $a0, 4
    li   $a2, 1
    li   $a3, 2
    jal  simular_un_partido

    # Partido 5: posicion 1 vs posicion 3
    li   $a0, 5
    li   $a2, 1
    li   $a3, 3
    jal  simular_un_partido

    # Partido 6: posicion 2 vs posicion 3
    li   $a0, 6
    li   $a2, 2
    li   $a3, 3
    jal  simular_un_partido

    lw   $ra, 0($sp)
    addiu $sp, $sp, 4
    jr   $ra


# ============================================================
#  simular_un_partido
#  $a0 = numero del partido (para mostrar)
#  $a2 = posicion equipo A en el grupo (0-3)
#  $a3 = posicion equipo B en el grupo (0-3)
#  Genera goles aleatorios, muestra resultado y actualiza GF/GC/PTS
# ============================================================
simular_un_partido:
    addiu $sp, $sp, -24
    sw    $ra,  0($sp)
    sw    $s0,  4($sp)                 # numero del partido
    sw    $s1,  8($sp)                 # posicion equipo A
    sw    $s2, 12($sp)                 # posicion equipo B
    sw    $s3, 16($sp)                 # goles equipo A
    sw    $s4, 20($sp)                 # goles equipo B

    move $s0, $a0
    move $s1, $a2
    move $s2, $a3

    # Generar goles
    jal  rand_0_5
    move $s3, $v0                      # goles A
    jal  rand_0_5
    move $s4, $v0                      # goles B

    # Mostrar: "Partido N: NombreA vs NombreB"
    li   $v0, 4
    la   $a0, msg_partido
    syscall
    li   $v0, 1
    move $a0, $s0
    syscall
    li   $v0, 4
    la   $a0, msg_dos_ptos
    syscall

    la   $t0, seleccion
    sll  $t1, $s1, 2
    add  $t0, $t0, $t1
    lw   $a0, 0($t0)
    jal  imprimir_nombre_pais

    li   $v0, 4
    la   $a0, msg_vs
    syscall

    la   $t0, seleccion
    sll  $t1, $s2, 2
    add  $t0, $t0, $t1
    lw   $a0, 0($t0)
    jal  imprimir_nombre_pais

    li   $v0, 4
    la   $a0, msg_nl
    syscall

    # Mostrar: "  Resultado: golesA - golesB"
    li   $v0, 4
    la   $a0, msg_resultado
    syscall
    li   $v0, 1
    move $a0, $s3
    syscall
    li   $v0, 4
    la   $a0, msg_guion
    syscall
    li   $v0, 1
    move $a0, $s4
    syscall
    li   $v0, 4
    la   $a0, msg_nl
    syscall

    # ---- Actualizar GF ----
    la   $t0, gf
    sll  $t1, $s1, 2
    add  $t1, $t0, $t1
    lw   $t2, 0($t1)
    add  $t2, $t2, $s3
    sw   $t2, 0($t1)                   # gf[A] += golesA

    sll  $t1, $s2, 2
    add  $t1, $t0, $t1
    lw   $t2, 0($t1)
    add  $t2, $t2, $s4
    sw   $t2, 0($t1)                   # gf[B] += golesB

    # ---- Actualizar GC ----
    la   $t0, gc
    sll  $t1, $s1, 2
    add  $t1, $t0, $t1
    lw   $t2, 0($t1)
    add  $t2, $t2, $s4
    sw   $t2, 0($t1)                   # gc[A] += golesB

    sll  $t1, $s2, 2
    add  $t1, $t0, $t1
    lw   $t2, 0($t1)
    add  $t2, $t2, $s3
    sw   $t2, 0($t1)                   # gc[B] += golesA

    # ---- Actualizar PUNTOS ----
    la   $t0, pts
    beq  $s3, $s4, partido_empate

    # Determinar ganador
    slt  $t1, $s4, $s3                 # t1 = 1 si golesA > golesB (A gana)
    beq  $t1, $zero, gana_B

    # Gana A: pts[A] += 3
    sll  $t1, $s1, 2
    add  $t1, $t0, $t1
    lw   $t2, 0($t1)
    addiu $t2, $t2, 3
    sw   $t2, 0($t1)
    j    fin_partido

gana_B:
    # Gana B: pts[B] += 3
    sll  $t1, $s2, 2
    add  $t1, $t0, $t1
    lw   $t2, 0($t1)
    addiu $t2, $t2, 3
    sw   $t2, 0($t1)
    j    fin_partido

partido_empate:
    # Empate: pts[A] += 1, pts[B] += 1
    sll  $t1, $s1, 2
    add  $t1, $t0, $t1
    lw   $t2, 0($t1)
    addiu $t2, $t2, 1
    sw   $t2, 0($t1)

    sll  $t1, $s2, 2
    add  $t1, $t0, $t1
    lw   $t2, 0($t1)
    addiu $t2, $t2, 1
    sw   $t2, 0($t1)

fin_partido:
    lw   $ra,  0($sp)
    lw   $s0,  4($sp)
    lw   $s1,  8($sp)
    lw   $s2, 12($sp)
    lw   $s3, 16($sp)
    lw   $s4, 20($sp)
    addiu $sp, $sp, 24
    jr   $ra


# ============================================================
#  mostrar_tabla
#  Muestra la tabla de posiciones del grupo (estado actual)
#  Formato: Pos  Pais  PJ  GF  GC  DG  PTS
# ============================================================
mostrar_tabla:
    addiu $sp, $sp, -8
    sw    $ra, 0($sp)
    sw    $s0, 4($sp)

    li   $v0, 4
    la   $a0, msg_encabez
    syscall
    li   $v0, 4
    la   $a0, msg_sep_tab
    syscall

    li   $s0, 0                        # i = 0
loop_tabla:
    beq  $s0, 4, fin_tabla

    # Posicion
    li   $v0, 1
    addi $a0, $s0, 1
    syscall
    li   $v0, 4
    la   $a0, msg_espacio4
    syscall

    # Nombre del pais
    la   $t0, seleccion
    sll  $t1, $s0, 2
    add  $t0, $t0, $t1
    lw   $a0, 0($t0)
    jal  imprimir_nombre_pais
    li   $v0, 4
    la   $a0, msg_tab
    syscall

    # PJ = siempre 3
    li   $v0, 1
    li   $a0, 3
    syscall
    li   $v0, 4
    la   $a0, msg_espacio2
    syscall

    # GF
    la   $t0, gf
    sll  $t1, $s0, 2
    add  $t0, $t0, $t1
    lw   $a0, 0($t0)
    li   $v0, 1
    syscall
    li   $v0, 4
    la   $a0, msg_espacio2
    syscall

    # GC
    la   $t0, gc
    sll  $t1, $s0, 2
    add  $t0, $t0, $t1
    lw   $t2, 0($t0)
    move $a0, $t2
    li   $v0, 1
    syscall
    li   $v0, 4
    la   $a0, msg_espacio2
    syscall

    # DG = GF - GC
    la   $t0, gf
    sll  $t1, $s0, 2
    add  $t0, $t0, $t1
    lw   $t3, 0($t0)
    sub  $a0, $t3, $t2                 # t2 ya tiene gc[i]
    li   $v0, 1
    syscall
    li   $v0, 4
    la   $a0, msg_espacio2
    syscall

    # PTS
    la   $t0, pts
    sll  $t1, $s0, 2
    add  $t0, $t0, $t1
    lw   $a0, 0($t0)
    li   $v0, 1
    syscall

    li   $v0, 4
    la   $a0, msg_nl
    syscall

    addi $s0, $s0, 1
    j    loop_tabla
fin_tabla:
    lw   $s0, 4($sp)
    lw   $ra, 0($sp)
    addiu $sp, $sp, 8
    jr   $ra


# ============================================================
#  bubble_sort
#  Ordena los 4 arreglos paralelos (seleccion, gf, gc, pts)
#  Criterio: puntos descendente; empate -> diferencia de goles descendente
# ============================================================
bubble_sort:
    addiu $sp, $sp, -12
    sw    $ra, 0($sp)
    sw    $s0, 4($sp)                  # limite exterior (n-1 a 1)
    sw    $s1, 8($sp)                  # indice interior j

    li   $s0, 4                        # n = 4
outer_loop:
    addi $s0, $s0, -1
    beq  $s0, $zero, fin_sort

    li   $s1, 0                        # j = 0
inner_loop:
    beq  $s1, $s0, end_inner

    # Cargar pts[j] y pts[j+1]
    la   $t0, pts
    sll  $t1, $s1, 2
    add  $t1, $t0, $t1
    lw   $t2, 0($t1)                   # pts[j]
    lw   $t3, 4($t1)                   # pts[j+1]

    # pts[j] > pts[j+1] -> ya en orden, no intercambiar
    slt  $t4, $t3, $t2                 # t4 = 1 si pts[j] > pts[j+1]
    bne  $t4, $zero, no_swap

    # pts[j] < pts[j+1] -> intercambiar
    slt  $t4, $t2, $t3                 # t4 = 1 si pts[j] < pts[j+1]
    bne  $t4, $zero, do_swap

    # pts iguales: comparar DG = GF - GC
    la   $t0, gf
    sll  $t4, $s1, 2
    add  $t4, $t0, $t4
    lw   $t4, 0($t4)                   # gf[j]
    la   $t0, gc
    sll  $t5, $s1, 2
    add  $t5, $t0, $t5
    lw   $t5, 0($t5)                   # gc[j]
    sub  $t4, $t4, $t5                 # DG[j]

    addi $t6, $s1, 1
    la   $t0, gf
    sll  $t6, $t6, 2
    add  $t0, $t0, $t6
    lw   $t6, 0($t0)                   # gf[j+1]
    addi $t7, $s1, 1
    la   $t0, gc
    sll  $t7, $t7, 2
    add  $t0, $t0, $t7
    lw   $t7, 0($t0)                   # gc[j+1]
    sub  $t6, $t6, $t7                 # DG[j+1]

    # DG[j] >= DG[j+1] -> no intercambiar
    slt  $t0, $t4, $t6                 # t0 = 1 si DG[j] < DG[j+1]
    beq  $t0, $zero, no_swap

do_swap:
    move $a0, $s1
    jal  intercambiar

no_swap:
    addi $s1, $s1, 1
    j    inner_loop

end_inner:
    j    outer_loop

fin_sort:
    lw   $s0, 4($sp)
    lw   $s1, 8($sp)
    lw   $ra, 0($sp)
    addiu $sp, $sp, 12
    jr   $ra


# ============================================================
#  intercambiar
#  $a0 = posicion j; intercambia j y j+1 en los 4 arreglos
#  Funcion hoja
# ============================================================
intercambiar:
    sll  $t0, $a0, 2                   # offset j
    addi $t1, $a0, 1
    sll  $t1, $t1, 2                   # offset j+1

    # Swap seleccion[j] y seleccion[j+1]
    la   $t2, seleccion
    add  $t3, $t2, $t0
    add  $t4, $t2, $t1
    lw   $t5, 0($t3)
    lw   $t6, 0($t4)
    sw   $t6, 0($t3)
    sw   $t5, 0($t4)

    # Swap gf[j] y gf[j+1]
    la   $t2, gf
    add  $t3, $t2, $t0
    add  $t4, $t2, $t1
    lw   $t5, 0($t3)
    lw   $t6, 0($t4)
    sw   $t6, 0($t3)
    sw   $t5, 0($t4)

    # Swap gc[j] y gc[j+1]
    la   $t2, gc
    add  $t3, $t2, $t0
    add  $t4, $t2, $t1
    lw   $t5, 0($t3)
    lw   $t6, 0($t4)
    sw   $t6, 0($t3)
    sw   $t5, 0($t4)

    # Swap pts[j] y pts[j+1]
    la   $t2, pts
    add  $t3, $t2, $t0
    add  $t4, $t2, $t1
    lw   $t5, 0($t3)
    lw   $t6, 0($t4)
    sw   $t6, 0($t3)
    sw   $t5, 0($t4)

    jr   $ra