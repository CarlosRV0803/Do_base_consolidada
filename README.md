# Do_base_consolidada
/*------------------------------------------
Proyecto: Motor de búsqueda
  Autor: UPP
  Última fecha de modificación: 28/01/2020
  Proposito: Obtener base consolidada
--------------------------------------------*/

clear all
set more off, perm

cd "C:\Users\analistaup12\Desktop\MINEDU\1. Proyecto\Insumos"
global filtro_ebr "(ges_dep=="A1" & (niv_mod=="A1" | niv_mod=="A2"  | niv_mod=="A3"  | niv_mod=="B0"  | niv_mod=="F0")) & d_estado=="Activa""
global cond_ini_u_rural "rural_upp!=0 & tipie_upp==200 & (niv_mod=="A1" | niv_mod=="A2"  | niv_mod=="A3")"
global cond_ini_p_rural "rural_upp!=0 & tipie_upp==140 & (niv_mod=="A1" | niv_mod=="A2"  | niv_mod=="A3")"
global cond_ini_p_urbano "rural_upp==0 & tipie_upp==140 & (niv_mod=="A1" | niv_mod=="A2"  | niv_mod=="A3")"
global cond_pri_u_rural "rural_upp!=0 & tipie_upp==200 & (niv_mod=="B0")"
global cond_pri_p_rural "rural_upp!=0 & tipie_upp==140 & (niv_mod=="B0")"
global cond_pri_p_urbano "rural_upp==0 & tipie_upp==140 & (niv_mod=="B0")"
global cond_pri_c_rural "rural_upp!=0 & tipie_upp==0 & (niv_mod=="B0")"
global cond_pri_c_urbano "rural_upp==0 & tipie_upp==0 & (niv_mod=="B0")"
global cond_sec_c_rural "rural_upp!=0 & tipie_upp==0 & (niv_mod=="F0")"
global cond_sec_c_urbano "rural_upp==0 & tipie_upp==0 & (niv_mod=="F0")"


