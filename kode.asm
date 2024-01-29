$MOD51
; Melakukan penamaan pin dengan instruksi equ
; Pin input
TANDON          equ P1.0
PAM             equ P1.1
SUMUR           equ P1.2

; Pin output
POMPA_PAM     	equ P1.3
POMPA_SUMUR 	equ P1.4

; Pin output (HASIL interrupt)
PPAM_RUSAK	equ P1.5 ;(P3.2)
PSUMUR_RUSAK	equ P1.6 ;(P3.3)


ORG  0000h		; vector untuk reset
sjmp init		; melompat ke init

; P3.2
ORG  0003h		; vector INT0 => Interrupt untuk pompa PAM rusak
CLR  POMPA_PAM		; Matikan pompa PAM
SETB PPAM_RUSAK		; Set bit untuk PPAM_RUSAK (1)
sjmp Start
reti			; Kembali ke program

; P3.3
ORG  0013h		; vector INT1 => Interrupt untuk pompa sumur rusak
CLR  POMPA_SUMUR		; Matikan pompa sumur
SETB PSUMUR_RUSAK	; Set bit untuk PSUMUR_RUSAK (1)
reti			; Kembali ke program


ORG  0030h		; vector program utama
init:			; Inisialisasi
CLR  POMPA_PAM		; Semua output dinolkan
CLR  POMPA_SUMUR
CLR  PPAM_RUSAK
CLR  PSUMUR_RUSAK

; Melakukan set untuk IT0 dan IT1 untuk mengubah mode interrupt
; dari low active menjadi falling-edge active.
SETB IT0
SETB IT1

; Aktivasi interrupt (Global, INT1, INT0)
; Diaktifkan EA (IE.7), EX1 (IE.2), dan EX0 (IE.0)
MOV  IE, #10000101B

Start:			; Program utama
JB   TANDON,POMPA_OFF	; Matikan pompa jika tandon penuh
JB   PAM,POMPAPAM_ON	; Nyalakan pompa PAM jika bak PAM penuh
JB   SUMUR,POMPASUMUR_ON; Nyalakan pompa sumur jika sumur penuh
AJMP POMPA_OFF		; Matikan semua pompa

POMPAPAM_ON:		; Untuk menyalakan pompa PAM
JB   PPAM_RUSAK,POMPASUMUR_ON ; Pengecekka status pompa rusak
CLR  POMPA_SUMUR	; Mematikan pompa sumur
SETB POMPA_PAM		; Menyalakan pompa PAM
AJMP Start		; Kembali ke Start

POMPASUMUR_ON:		; Untuk menyalakan pompa sumur
JB   PSUMUR_RUSAK,POMPA_OFF ; Pengecekkan status pompa rusak
CLR  POMPA_PAM		; Mematikan pompa PAM
SETB POMPA_SUMUR	; Menyalakan pompa sumur
AJMP Start		; Kembali ke Start

POMPA_OFF:		; Untuk mematikan semua pompa
CLR  POMPA_SUMUR	; Mematikan pompa sumur
CLR  POMPA_PAM		; Mematikan pompa pam
AJMP Start		; Kembali ke Start
End
