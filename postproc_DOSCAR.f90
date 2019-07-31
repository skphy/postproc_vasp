! Program to read the DOSCAR file in VASP, and write the output 
! according to a format.
! --> To write total dos in TotalDos.dat
! --> To write lm and site projected dos lmSiteDos.dat
!==================================================
! Author: SK, Date: 7Apr2014
! email: sonukumar.physics@gmail.com
!==================================================
PROGRAM RW_DOSCAR

	Implicit None

	Character(20) :: system_name	
	Integer :: nionp, nions, jobpar, ncdij   ! these are dummy variables, no meaning here 
	Real    :: aomega, anorm1, anorm2, anorm3, potim ! -do- 
	Real    :: emax, emin, efermi  ! max of energy, min of energy,  fermi level
	! en = energy points, ddos = tot. dos, ddosi = integrated tot. dos,  ispin = spin index
	Integer :: i, ii, isp, ispin, ierr, ndos !ispin= spin index, ndos=no of energy points,
	Real	:: en  
	! For total dos
	Real, allocatable:: ddos(:,:), ddosi(:,:)  
	! For lm and site projected dos
	Real, allocatable:: s_dos(:,:), &  ! s componet
			& p1_dos(:,:), p2_dos(:,:), p3_dos(:,:), &  ! three p components
			& d1_dos(:,:), d2_dos(:,:), d3_dos(:,:), d4_dos(:,:), d5_dos(:,:), & ! five d components
			& f1_dos(:,:), f2_dos(:,:), f3_dos(:,:), f4_dos(:,:), f5_dos(:,:), f6_dos(:,:), f7_dos(:,:)!seven f states

	Logical :: lFstates  ! for f states
	!lFstates=.False.			

	OPEN(unit=1, file="DOSCAR", form="formatted", status="old", iostat=ierr)	
	OPEN(unit=2, file="TotalDos.dat", form="formatted", status="replace") !, iostat="ierr")		
	IF(ierr==0) THEN
		WRITE(*,*) "Reading DOSCAR ..."
	ELSE
		WRITE(*,*) "Error reading DOSCAR .. stoping !!"
		STOP
	ENDIF
	
	Write(*,*) "++-----------------------------++"
	Write(*,*) "No-Spin ->1 ; Spin -> 2"
	Write(*,*) "++-----------------------------++"
	Read(*,*) ispin
	
	Write(*,*) "++----------------------------------------++"
	Write(*,*) "f states -> t/true ; no f states -> f/false"
	Write(*,*) "++----------------------------------------++"
	Read(*,*) lFstates
	
!Reading the DOSCAR file
	READ(1,'(4I4)') nionp, nions, jobpar, ncdij 
	READ(1,'(5E15.7)') aomega, anorm1, anorm2, anorm3, potim 
	READ(1,*)     ! 
	READ(1,*)     ! CAR 
	READ(1,'(a)') system_name 	
! 	reading max of energy, min of energy, no of energy points, fermi level, (not reading last one i.e. "1" )
	READ(1,'(2F16.8,I5,F16.8)') emax, emin, ndos, efermi
	WRITE(2, *) "#   emax	emin	 ndos	 efermi(0 eV)	"
	WRITE(2,'(a,2F16.8,I5,F16.8)') " #", emax-efermi, emin-efermi, ndos, efermi-efermi	

!	Doing allocation	
	Allocate (ddos(ndos,ispin), ddosi(ndos,ispin))

	If(ispin==2) then
		Do i=1, ndos
			READ(1,7414)   en, (ddos(i,isp), isp=1,ispin),(ddosi(i,isp), isp=1,ispin)
			WRITE(2,7414)  en-efermi, (ddos(i,isp), isp=1,ispin),(ddosi(i,isp), isp=1,ispin)
		Enddo		
	Else
		Do i=1, ndos
			READ(1,7415) en, (ddos(i,isp), isp=1,ispin),(ddosi(i,isp), isp=1,ispin)
			WRITE(2,7415) en-efermi, (ddos(i,isp), isp=1,ispin),(ddosi(i,isp), isp=1,ispin)
		Enddo		
	Endif			
7414	FORMAT(3X, F8.3, 4E12.4)  
7415	FORMAT(3X, F8.3, 2E12.4)  

!	deallocating the variables
	Deallocate (ddos, ddosi)

	If (.not.lFstates) then
		Allocate (s_dos(ndos,ispin), p1_dos(ndos,ispin), p2_dos(ndos,ispin), p3_dos(ndos,ispin), &
		& d1_dos(ndos,ispin), d2_dos(ndos,ispin), d3_dos(ndos,ispin), d4_dos(ndos,ispin), d5_dos(ndos,ispin))
	Else
		Allocate (s_dos(ndos,ispin), p1_dos(ndos,ispin), p2_dos(ndos,ispin), p3_dos(ndos,ispin), &
		& d1_dos(ndos,ispin), d2_dos(ndos,ispin), d3_dos(ndos,ispin), d4_dos(ndos,ispin), d5_dos(ndos,ispin), &
		& f1_dos(ndos,ispin), f2_dos(ndos,ispin), f3_dos(ndos,ispin), f4_dos(ndos,ispin), f5_dos(ndos,ispin), &
		f6_dos(ndos,ispin), f7_dos(ndos,ispin))
	endif

	OPEN(unit=3, file="lmSiteDos.dat", form="formatted", status="replace") 	

!	Looping over the all the atoms 
	Do i=1, nionp
		Read(1,*)
!		Write(3,*)"# emax  emin  ndos  efermi(0 eV)   atom_number"
		Write(3,*)" #  emax  emin  ndos  efermi   atom_number"
		Write(3,'(a,2F16.8,I5,F16.8, I3)') " #", emax-efermi, emin-efermi, ndos, (efermi-efermi), i
		! for ispin=1, eneng, s-dos, p-dos, d-dos
		! for ispin=2, eneng, s-dos_up, s-dos_dn, p-dos_up, p-dos_dn, , d-dos_up, d-dos_dn
		If(ispin==2) then
			If(.not.lFstates) then
				WRITE(3,*)"# eneng, s-dos_up, s-dos_dn, p-dos_up, p-dos_dn, d-dos_up, d-dos_dn"
				Do ii=1, ndos
					READ(1,7416) en, (s_dos(i,isp), isp=1,ispin), & 
					& (p1_dos(i,isp), p2_dos(i,isp), p3_dos(i,isp), isp=1,ispin), &
					& (d1_dos(i,isp), d2_dos(i,isp), d3_dos(i,isp), d4_dos(i,isp), &
					& d5_dos(i,isp), isp=1,ispin)
					WRITE(3,7416) en-efermi, (s_dos(i,isp), isp=1,ispin), & 
					& (p1_dos(i,isp), p2_dos(i,isp), p3_dos(i,isp), isp=1,ispin), &
					& (d1_dos(i,isp), d2_dos(i,isp), d3_dos(i,isp), d4_dos(i,isp), &
					& d5_dos(i,isp), isp=1,ispin)				
				Enddo	
				Write(3,*)   ! to separate the different atom contributions 
				Write(3,*)   !				
			Else
				WRITE(3,*)"# eneng, s-dos_up, s-dos_dn, p-dos_up, p-dos_dn, d-dos_up, d-dos_dn, f-dos_up, f-dos_dn"
				Do ii=1, ndos
					READ(1,7418) en, (s_dos(i,isp), isp=1,ispin), & 
					& (p1_dos(i,isp), p2_dos(i,isp), p3_dos(i,isp), isp=1,ispin), &
					& (d1_dos(i,isp), d2_dos(i,isp), d3_dos(i,isp), d4_dos(i,isp), &
					& d5_dos(i,isp), isp=1,ispin), &
					& (f1_dos(i,isp), f2_dos(i,isp), f3_dos(i,isp), f4_dos(i,isp), &
					& f5_dos(i,isp), f6_dos(i,isp), f7_dos(i,isp), isp=1,ispin)
					WRITE(3,7418) en-efermi, (s_dos(i,isp), isp=1,ispin), & 
					& (p1_dos(i,isp), p2_dos(i,isp), p3_dos(i,isp), isp=1,ispin), &
					& (d1_dos(i,isp), d2_dos(i,isp), d3_dos(i,isp), d4_dos(i,isp), &
					& d5_dos(i,isp), isp=1,ispin), &
					& (f1_dos(i,isp), f2_dos(i,isp), f3_dos(i,isp), f4_dos(i,isp), &
					& f5_dos(i,isp), f6_dos(i,isp), f7_dos(i,isp), isp=1,ispin)		
				Enddo	
				Write(3,*)   ! to separate the different atom contributions 
				Write(3,*)   !				
			Endif
		Else
			If(.not.lFstates) then
				WRITE(3,*)"# eneng, s-dos, p-dos, d-dos"
				Do ii=1, ndos
					READ(1,7417) en, (s_dos(i,isp), isp=1,ispin), & 
					& (p1_dos(i,isp), p2_dos(i,isp), p3_dos(i,isp), isp=1,ispin), &
					& (d1_dos(i,isp), d2_dos(i,isp), d3_dos(i,isp), d4_dos(i,isp), &
					& d5_dos(i,isp), isp=1,ispin)
					WRITE(3,7417) en-efermi, (s_dos(i,isp), isp=1,ispin), & 
					& (p1_dos(i,isp), p2_dos(i,isp), p3_dos(i,isp), isp=1,ispin), &
					& (d1_dos(i,isp), d2_dos(i,isp), d3_dos(i,isp), d4_dos(i,isp), &
					& d5_dos(i,isp), isp=1,ispin)			
				Enddo		
				Write(3,*) 	
				Write(3,*) 			
			Else
				WRITE(3,*)"# eneng, s-dos, p-dos, d-dos, f-dos"
				Do ii=1, ndos
					READ(1,7419) en, (s_dos(i,isp), isp=1,ispin), & 
					& (p1_dos(i,isp), p2_dos(i,isp), p3_dos(i,isp), isp=1,ispin), &
					& (d1_dos(i,isp), d2_dos(i,isp), d3_dos(i,isp), d4_dos(i,isp), &
					& d5_dos(i,isp), isp=1,ispin), &
					& (f1_dos(i,isp), f2_dos(i,isp), f3_dos(i,isp), f4_dos(i,isp), &
					& f5_dos(i,isp), f6_dos(i,isp), f7_dos(i,isp), isp=1,ispin)
					WRITE(3,7419) en-efermi, (s_dos(i,isp), isp=1,ispin), & 
					& (p1_dos(i,isp), p2_dos(i,isp), p3_dos(i,isp), isp=1,ispin), &
					& (d1_dos(i,isp), d2_dos(i,isp), d3_dos(i,isp), d4_dos(i,isp), &
					& d5_dos(i,isp), isp=1,ispin), &
					& (f1_dos(i,isp), f2_dos(i,isp), f3_dos(i,isp), f4_dos(i,isp), &
					& f5_dos(i,isp), f6_dos(i,isp), f7_dos(i,isp), isp=1,ispin)							
				Enddo		
				Write(3,*) 	
				Write(3,*) 	
			Endif			
7416	FORMAT(3X, F8.3, 18E12.4)  
7418	FORMAT(3X, F8.3, 18E12.4, 14E12.4) ! 14E12.4 for f states with spin 

7417	FORMAT(3X, F8.3, 9E12.4)  
7419	FORMAT(3X, F8.3, 9E12.4, 7E12.4) !7E12.4   for f states without spin
		Endif
	Enddo
!	deallocating the variables


	If(.not.lFstates)then
	
		Deallocate (s_dos, p1_dos, p2_dos, p3_dos, &
		& d1_dos, d2_dos, d3_dos, d4_dos, d5_dos)
	Else
		Deallocate (s_dos, p1_dos, p2_dos, p3_dos, &
		& d1_dos, d2_dos, d3_dos, d4_dos, d5_dos, &
		& f1_dos, f2_dos, f3_dos, f4_dos, f5_dos, f6_dos, f7_dos)
	Endif
	
	Close(1)
	Close(2)
	Close(3)
END PROGRAM RW_DOSCAR
