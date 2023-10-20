BITS 32

jmp short bootloader_start                                                                         		 	 ; Jump to the start of the bootloader
nop                                                                                                		     ; The reason for nop is to jump over the disk information


; -------------------------------------------------------------------
; SECTOR 0: BPB (Bios Parameter Block)
; -------------------------------------------------------------------
OEMLabel                     db                  "KNIGHTOS"                                                  ; OEM name
BytesPerSector               dw                  512                                                         ; Bytes per sector
SectorsPerCluster            db                  8                                                           ; Sectors per cluster
ReservedSectors              dw                  32                                                          ; Reserved sectors for boot record
NumberOfFats                 db                  2                                                           ; Number of FATs
RootDirEntries               dw                  0                                                           ; For FAT32, set to 0
TotalSectors16               dw                  0                                                           ; For FAT32, set to 0
Media                        db                  0xF8                                                        ; Media descriptor (fixed disk)
SectorsPerFat16              dw                  0                                                           ; For FAT32, set to 0
SectorsPerTrack              dw                  63                                                          ; Sectors per track
Heads                        dw                  255                                                         ; Number of heads
HiddenSectors                dd                  0                                                           ; Number of hidden sectors
TotalSectors32               dd                  0                                                           ; Total sectors (use 32-bit value for FAT32)

; -------------------------------------------------------------------
; SECTOR 1: EBR (Extended Boot Record)
; -------------------------------------------------------------------
SectorsPerFat32              dd                  0                                                           ; Sectors per FAT (set to 0 for FAT32)
Flags                        dw                  0                                                           ; Flags (typically 0)
FileSystemVersion            dd                  0                                                           ; File system version (typically 0)
RootCluster                  dd                  2                                                           ; First cluster of the root directory (typically 2)
FileSystemInfoSector         dw                  1                                                           ; File system information sector
BackupBootSector             dw                  6                                                           ; Backup boot sector
Reserved                     db                  12                                                          ; Reserved bytes
DriveNumber                  db                  0x80                                                        ; Drive number (typically 0x80)
WinNtFlags                   db                  0                                                           ; Windows NT flags (typically 0)
Signature                    db                  0x29                                                        ; Signature (0x28 and 0x29 are common)
VolumeID                     dd                  0xAB29F1C7                                                  ; A unique volume ID
VolumeLabel                  db                  "MYFAT32"                                                   ; Volume label
FileSystem                   db                  "FAT32   "                                                  ; File system type

; -------------------------------------------------------------------
; SECTOR 2: FSinfo Structure (File System Information)
; -----------------------------------------------------------
FSInfoLeadSignature           dd                 0x41615252                                                  ; FSINFO lead signature ("RRaA")
FSInfoStructureSignature      dd                 0x61417272                                                  ; FSINFO structure signature ("rrAa")
FreeClusterCount              dd                 0xFFFFFFFF                                                  ; Number of free clusters (set to a placeholder value)
MostRecentCluster             dd                 0xFFFFFFFF                                                  ; Most recently allocated cluster (set to a placeholder value)
Reserved                      dd                 0x00000000                                                  ; Reserved (typically set to 0x00000000)
FSInfoSignature               dd                 0xAA550000                                                  ; FSinfo sector signature (for the end of the sector)


; -------------------------------------------------------------------
; Main bootloader code
; -------------------------------------------------------------------
bootloader_start:



; -------------------------------------------------------------------
; END OF BOOTLOADER
; -------------------------------------------------------------------
dw 0AA55h                                                                                                    ; Boot signature