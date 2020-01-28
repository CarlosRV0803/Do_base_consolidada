/*------------------------------------------------------------------------------

Proyecto: 									Base consolidada 
Autor: 										Carlos Ramírez - Racionalización - UPP
Ultima fecha de modificación:				27/01/2020
Proposito:									Obtener una base consolidada de Padron, NEXUS y Siagie
											
------------------------------------------------------------------------------*/

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

*****************************************************************
*          1. Base consolidada (Padron, NEXUS y Siagie)    
*****************************************************************

*===============================
*1.1 Importar la base del Padrón
*===============================
import dbase Padron_web.dbf, clear case(l)
save Padron_2020_raw.dta, replace
run "Actualización padron"

*===============================
*1.2 Reshape Siagie
*===============================
use Siagie_apilado_2015_2019.dta, clear
reshape wide cant* num_secc, i(cod_mod anexo nivel_servicio) j(id_anio)
save siagie_wide_2015_2019.dta, replace

*===============================
*1.3 Limpieza de NEXUS
*===============================
use nexus_2sira.dta, clear
run "Seguimiento EBR"
save nexus_sira_2020.dta, replace

*===============================
*Merge
*===============================
use Padron_2020.dta, clear
merge 1:1 cod_mod anexo using siagie_wide_2015_2019.dta, nogen
merge m:1 cod_mod using nexus_sira_2020.dta, keep(2 3)
*export excel cod_mod using "codigo_modular_consulta.xlsx" if _merge==2, firstrow(variables) replace
drop _merge

forvalues x = 0/6{
	forvalues y = 2015/2019{
	replace cant`x'_alum`y'= 0 if cant`x'_alum`y'==.
	replace cant_total`y'= 0 if cant_total`y'==.
	}
}

save base_consolidada.dta, replace

*****************************************************************
*          2. Norma Técnica - RVM 307 - 2019 - MINEDU
*****************************************************************
/*Plaza orgánica: Si se encuentra vacante puede ser cubierta por personal nombrado o contratado (temporalmente).
*Plaza eventual: Solo es cubierta por contratados.
*Se utiliza el SIRA vigente
*/	
	
*Calcular plaza docente necesaria según cantidad de alumnos por sección
gen plaza_doc_nec = 0
replace plaza_doc_nec = round(cant_total2019/15) if $cond_ini_u_rural & $filtro_ebr
replace plaza_doc_nec = round(cant_total2019/20) if $cond_ini_p_rural & $filtro_ebr
replace plaza_doc_nec = round(cant_total2019/25) if $cond_ini_p_urbano  & $filtro_ebr
replace plaza_doc_nec = round(cant_total2019/15) if $cond_pri_u_rural & $filtro_ebr
replace plaza_doc_nec = round(cant_total2019/20) if $cond_pri_p_rural & $filtro_ebr
replace plaza_doc_nec = round(cant_total2019/25) if $cond_pri_p_urbano & $filtro_ebr
replace plaza_doc_nec = round(cant_total2019/25) if $cond_pri_c_rural & $filtro_ebr
replace plaza_doc_nec = round(cant_total2019/30) if $cond_pri_c_urbano & $filtro_ebr
replace plaza_doc_nec = round(cant_total2019/25) if $cond_sec_c_rural & $filtro_ebr
replace plaza_doc_nec = round(cant_total2019/30) if $cond_sec_c_urbano & $filtro_ebr
gen plaza_e = plaza_doc - plaza_doc_nec	



*****************************************************************
*          3. Criterios de flexibilidad
*****************************************************************






