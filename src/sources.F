!------------------------------------------------------------------------------------
!
!      FILE sources.F
!
!      This file is part of the FUNWAVE-TVD program under the Simplified BSD license
!
!-------------------------------------------------------------------------------------
! 
!    Copyright (c) 2016, FUNWAVE Development Team
!
!    (See http://www.udel.edu/kirby/programs/funwave/funwave.html
!     for Development Team membership)
!
!    All rights reserved.
!
!    FUNWAVE_TVD is free software: you can redistribute it and/or modify
!    it under the terms of the Simplified BSD License as released by
!    the Berkeley Software Distribution (BSD).
!
!    Redistribution and use in source and binary forms, with or without
!    modification, are permitted provided that the following conditions are met:
!
!    1. Redistributions of source code must retain the above copyright notice, this
!       list of conditions and the following disclaimer.
!    2. Redistributions in binary form must reproduce the above copyright notice,
!    this list of conditions and the following disclaimer in the documentation
!    and/or other materials provided with the distribution.
!
!    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
!    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
!    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
!    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
!    ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
!    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
!    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
!    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
!    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
!    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
!  
!    The views and conclusions contained in the software and documentation are those
!    of the authors and should not be interpreted as representing official policies,
!    either expressed or implied, of the FreeBSD Project.
!  
!-------------------------------------------------------------------------------------
!
!    SourceTerms is subroutine for all source terms
!
!    HISTORY: 
!       05/01/2010 Fengyan Shi
!       09/26/2013 Babak Tehranirad, added 2D Cd
!       08/18/2015 YoungKwang Choi, modified viscosity breaking
!       02/08/2016 Fengyan Shi, corrected wavemaker corresponding to 
!                               conservative form of momentum equations
!
! --------------------------------------------------
FUNCTION sq(X)
      USE PARAM
      IMPLICIT NONE
      REAL(SP) :: sq
      REAL(SP), INTENT(IN) :: x
      sq = X*X
END FUNCTION

MODULE veg
CONTAINS
  FUNCTION veg_integrand_x(z,u0,v0,alpha,beta,h,hx,hy,hxx,hxy,hyy,eta,&
             v0x, v0y, v0yy, v0xy, u0x, u0y, u0xx, u0xy)
     USE PARAM
     IMPLICIT NONE
     REAL(SP), INTENT(IN) :: z
     REAL(sp), INTENT(IN) :: u0, v0, alpha, beta, h, hx, hy, hxx, hyy, hxy, eta
     REAL(sp), INTENT(IN) :: v0x, v0y, v0yy, v0xy
     REAL(sp), INTENT(IN) :: u0x, u0y, u0xx, u0xy
     REAL(SP) :: ux, uy
     REAL(SP) :: veg_integrand_x
     ux = u0 + ((beta*eta + alpha*h - z)*(2*hxx*u0 + beta*eta*u0xx + 2*h*u0xx + &
       alpha*h*u0xx + 2*hxy*v0 + 2*hy*v0x + beta*eta*v0xy + 2*h*v0xy + alpha*h*v0xy + &
       2*hx*(2*u0x + v0y) + u0xx*z + v0xy*z))/2.
     uy = v0 + ((beta*eta + alpha*h - z)*(2*hxy*u0 + beta*eta*u0xy + 2*h*u0xy + &
       alpha*h*u0xy + 2*hx*u0y + 2*hyy*v0 + 2*hy*(u0x + 2*v0y) + beta*eta*v0yy + 2*h*v0yy + &
       alpha*h*v0yy + u0xy*z + v0yy*z))/2.
     veg_integrand_x = sqrt(ux**2+uy**2)*ux
  END FUNCTION
  FUNCTION veg_integrand_y(z,u0,v0,alpha,beta,h,hx,hy,hxx,hxy,hyy,eta,&
             v0x, v0y, v0yy, v0xy, u0x, u0y, u0xx, u0xy)
     USE PARAM
     IMPLICIT NONE
     REAL(SP), INTENT(IN) :: z
     REAL(sp), INTENT(IN) :: u0, v0, alpha, beta, h, hx, hy, hxx, hyy, hxy, eta
     REAL(sp), INTENT(IN) :: v0x, v0y, v0yy, v0xy
     REAL(sp), INTENT(IN) :: u0x, u0y, u0xx, u0xy
     REAL(SP) :: ux, uy
     REAL(SP) :: veg_integrand_y
     ux = u0 + ((beta*eta + alpha*h - z)*(2*hxx*u0 + beta*eta*u0xx + 2*h*u0xx + &
       alpha*h*u0xx + 2*hxy*v0 + 2*hy*v0x + beta*eta*v0xy + 2*h*v0xy + alpha*h*v0xy + &
       2*hx*(2*u0x + v0y) + u0xx*z + v0xy*z))/2.
     uy = v0 + ((beta*eta + alpha*h - z)*(2*hxy*u0 + beta*eta*u0xy + 2*h*u0xy + &
       alpha*h*u0xy + 2*hx*u0y + 2*hyy*v0 + 2*hy*(u0x + 2*v0y) + beta*eta*v0yy + 2*h*v0yy + &
       alpha*h*v0yy + u0xy*z + v0yy*z))/2.
     veg_integrand_y = sqrt(ux**2+uy**2)*uy
  END FUNCTION
  FUNCTION veg_integral_x(zlo,zhi,npts, &
             u0,v0,alpha,beta,h,hx,hy,hxx,hxy,hyy,eta,&
             v0x, v0y, v0yy, v0xy, u0x, u0y, u0xx, u0xy)
     USE PARAM
     IMPLICIT NONE
     REAL(SP), INTENT(IN) :: zlo,zhi
     INTEGER :: npts
     REAL(sp), INTENT(IN) :: u0, v0, alpha, beta, h, hx, hy, hxx, hyy, hxy, eta
     REAL(sp), INTENT(IN) :: v0x, v0y, v0yy, v0xy
     REAL(sp), INTENT(IN) :: u0x, u0y, u0xx, u0xy
     REAL(sp) :: dz, zsum, z, veg_integral_x
     dz = (zhi-zlo)/npts
     do i = 1, npts
       z = zlo+(i-.5)*dz
       zsum = zsum + veg_integrand_x(z,u0,v0,alpha,beta,h,hx,hy,hxx,hxy,hyy,eta,&
             v0x, v0y, v0yy, v0xy, u0x, u0y, u0xx, u0xy)
     enddo
     veg_integral_x = zsum
  END FUNCTION
  FUNCTION veg_integral_y(zlo,zhi,npts, &
             u0,v0,alpha,beta,h,hx,hy,hxx,hxy,hyy,eta,&
             v0x, v0y, v0yy, v0xy, u0x, u0y, u0xx, u0xy)
     USE PARAM
     IMPLICIT NONE
     REAL(SP), INTENT(IN) :: zlo,zhi
     INTEGER :: npts
     REAL(sp), INTENT(IN) :: u0, v0, alpha, beta, h, hx, hy, hxx, hyy, hxy, eta
     REAL(sp), INTENT(IN) :: v0x, v0y, v0yy, v0xy
     REAL(sp), INTENT(IN) :: u0x, u0y, u0xx, u0xy
     REAL(sp) :: dz, zsum, z, veg_integral_y
     dz = (zhi-zlo)/npts
     do i = 1, npts
       z = zlo+(i-.5)*dz
       zsum = zsum + veg_integrand_x(z,u0,v0,alpha,beta,h,hx,hy,hxx,hxy,hyy,eta,&
             v0x, v0y, v0yy, v0xy, u0x, u0y, u0xx, u0xy)
     enddo
     veg_integral_y = zsum
  END FUNCTION
END MODULE


SUBROUTINE SourceTerms
     USE GLOBAL
# if defined (VESSEL)
     USE VESSEL_MODULE
# endif
# if defined (METEO)
     USE METEO_MODULE
# endif

     USE VEG
     IMPLICIT NONE
     REAL,DIMENSION(Mloc,Nloc) :: nu_vis
     LOGICAL :: PQ_scheme = .FALSE.
     REAL(SP) :: xmk,ymk,Dxg,Dyg,WK_Source
     REAL(SP) :: z0,z2,fac,fricx,fricy,dely,delx,hval,rr,th
     REAL(SP) :: hx,hxx,hy,hyy,hxy
     REAL(SP) :: a_x,a_y,b_x,b_y,C0_x,C0_y,C1_x,C1_y,C2_x,C2_y,s
     REAL(SP) :: zterm0,zterm1,zterm2,zup,zdn,za
     !REAL(SP) :: veg_cd,veg_n,veg_bv
     REAL(SP), PARAMETER :: alpha_v = -.53, beta_v = .47
     INTEGER, PARAMETER :: npts = 15
     INTEGER :: kd,kf
     INTERFACE
       FUNCTION sq(x)
         USE PARAM
         REAL(SP) :: sq
         REAL(SP), INTENT(IN) :: x
       END FUNCTION
     END INTERFACE

# if defined (CARTESIAN)
     DXg=DX
     DYg=DY
# else
! only for wavemaker
     DXg=DX(1,1)
     DYg=DY(1,1)
# endif


! wavemaker fyshi 02/08/2016

          DO J=1,Nloc
          DO I=1,Mloc

# if defined (PARALLEL)
![---ykchoi Jan/23/2018
!            xmk=(I-Ibeg)*DXg+npx*(Mloc-2*Nghost)*DXg
!            ymk=(J-Jbeg)*DYg+npy*(Nloc-2*Nghost)*DYg
	      xmk=(I-Ibeg)*DXg + (iista-1)*DXg
	      ymk=(J-Jbeg)*DYg + (jjsta-1)*DYg
!---ykchoi Jan/23/2018]
# else
            xmk=(I-Ibeg)*DXg
            ymk=(J-Jbeg)*DYg
# endif
         IF(ABS(xmk-Xc_WK)<Width_WK.AND. &
            ABS(ymk-Yc_WK)<Ywidth_WK/2.0_SP)THEN

       IF(WAVEMAKER(1:6)=='WK_REG')THEN          
          WaveMaker_Mass(I,J)=TANH(PI/(Time_ramp*Tperiod)*TIME)*D_gen &
                 *EXP(-Beta_gen*(xmk-Xc_WK)**2)&
                 *SIN(rlamda*(ymk-ZERO)-2.0_SP*PI/Tperiod*TIME)    
       ENDIF

!  added TMA_1D and JON_1D 02/24/2017

        IF(WaveMaker(1:6)=='WK_IRR'.OR.WaveMaker(1:6)=='TMA_1D'  &
           .OR.WaveMaker(1:6)=='JON_1D'.OR.WaveMaker(1:6)=='JON_2D')THEN
          WK_Source=ZERO
          DO kf=1,Nfreq
           WK_Source=WK_Source+TANH(PI/(Time_ramp/FreqPeak)*TIME)*(Cm(I,J,kf) &
                       *COS(OMGN_IR(KF)*TIME) &
                       +Sm(I,J,kf)*SIN(OMGN_IR(KF)*TIME))
          ENDDO
          WaveMaker_Mass(I,J)=WK_Source

       ENDIF

       IF(WAVEMAKER(1:7)=='WK_TIME')THEN
           WK_Source=ZERO
           DO kf=1,NumWaveComp
             WK_Source=WK_Source &
               +TANH(PI/(Time_ramp*PeakPeriod)*TIME)*D_genS(kf) &
                 *EXP(-Beta_genS(kf)*(xmk-Xc_WK)**2)&
                 *COS(2.0_SP*PI/WAVE_COMP(kf,1)*TIME-WAVE_COMP(kf,3)) 
           ENDDO
          WaveMaker_Mass(I,J)=WK_Source
       ENDIF

       IF(WAVEMAKER(1:9)=='WK_DATA2D')THEN

        ! make the efficient scheme using Cm and Sm 06/07/2016 fyshi
          WK_Source=ZERO

          DO kf=1,NumFreq
           WK_Source=WK_Source+TANH(PI/(Time_ramp/FreqPeak)*TIME)*(Cm(I,J,kf) &
                       *COS(OMGN2D(KF)*TIME) &
                       +Sm(I,J,kf)*SIN(OMGN2D(KF)*TIME))
          ENDDO
          WaveMaker_Mass(I,J)=WK_Source
       ENDIF

      ENDIF ! end maker domain

         ENDDO
         ENDDO

! ----

     nu_vis=ZERO	
	! ykchoi(08.18.2015)
	! new variable :: WAVEMAKER_VIS
        ! should include ghost cells 02/28/2017 fyshi

      !IF(VISCOSITY_BREAKING)THEN
      IF(VISCOSITY_BREAKING .OR. WAVEMAKER_VIS)THEN

        nu_vis = nu_break

# if defined (DEEP_DRAFT_VESSEL)
       nu_vis = nu_vis + VisVessel_2D
# endif

!       DO J=Jbeg,Jend
!       DO I=Ibeg,Iend
!         nu_vis(I,J)=nu_break(I,J)
!       ENDDO
!       ENDDO

      ENDIF


     IF(DIFFUSION_SPONGE)THEN
!    should include ghost cells 02/28/2017, fyshi

       nu_vis = nu_vis + nu_sponge

!       DO J=Jbeg,Jend
!       DO I=Ibeg,Iend
!         nu_vis(I,J)=nu_vis(I,J)+nu_sponge(I,J)
!       ENDDO
!       ENDDO          

     ENDIF

107  format(500f12.6)

! depth gradient term
     DO J=Jbeg,Jend
     DO I=Ibeg,Iend

# if defined (CARTESIAN)

! second order, move the second term to left-hand side
       SourceX(I,J)=GRAV*(Eta(I,J))/DX*(Depthx(I+1,J)-Depthx(I,J))*MASK(I,J) &
 ! friction
# if defined (MANNING)
                   -(GRAV*Cd(I,J)**2/  &
                   Max(H(I,J),MinDepthFrc)**(0.333333_SP))  &
                   *U(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# else
                   -Cd(I,J)*U(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# endif

                       ! dispersion
                       ! (h+eta)(u*\nabla V4 + V4 * \nabla u - v1pp-v2-v3)
                   + Gamma1*MASK9(I,J)*Max(H(I,J),MinDepthFrc)*(         & 
                     U(I,J)*0.5_SP*(U4(I+1,J)-U4(I-1,J))/DX+V(I,J)*0.5_SP*(U4(I,J+1)-U4(I,J-1))/DY &
                     +U4(I,J)*0.5_SP*(U(I+1,J)-U(I-1,J))/DX+V4(I,J)*0.5_SP*(U(I,J+1)-U(I,J-1))/DY  &
                     -Gamma2*MASK9(I,J)*(U1pp(I,J)+U2(I,J)+U3(I,J)) &
                     )    &
                        ! Ht(-V4+V1p) = div(M)*(U4-U1p)
                    +Gamma1*MASK9(I,J)*((P(I+1,J)-P(I,J))/DX+(Q(I,J+1)-Q(I,J))/DY) &
                      *(U4(I,J)-U1p(I,J)) &
! wavemaker
                   +WaveMaker_Mass(I,J)*U(I,J)

       IF(FRICTION_SPONGE) THEN
          ! note that, compared to wei et al, we used flux. so need multiply D
          SourceX(I,J) = SourceX(I,J) &
                 - CD_4_SPONGE(I,J)*U(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
                   *Depth(I,J)
       ENDIF

# if defined (DEEP_DRAFT_VESSEL)
          SourceX(I,J) = SourceX(I,J) &
                   -CdVessel_2D(I,J)*U(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J))
# endif

       IF(WaveMakerCurrentBalance)THEN
# if defined (PARALLEL)
	      xmk=(I-Ibeg)*DXg + (iista-1)*DXg
	      ymk=(J-Jbeg)*DYg + (jjsta-1)*DYg
# else
            xmk=(I-Ibeg)*DXg
            ymk=(J-Jbeg)*DYg
# endif
         IF(ABS(xmk-Xc_WK)<Width_WK.AND. &
            ABS(ymk-Yc_WK)<Ywidth_WK/2.0_SP)THEN
            SourceX(I,J) = SourceX(I,J) &
                  -WaveMakerCd*U(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J))
         ENDIF
       ENDIF ! current balance

       IF(BREAKWATER) THEN
          ! note that, compared to wei et al, we used flux. so need multiply D
          SourceX(I,J) = SourceX(I,J) &
                 - CD_breakwater(I,J)*U(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
                   *Depth(I,J)
       ENDIF
          
       SourceY(I,J)=GRAV*(Eta(I,J))/DY*(Depthy(I,J+1)-Depthy(I,J))*MASK(I,J) &
                          ! friction
# if defined (MANNING)
                   -(GRAV*Cd(I,J)**2/  &
                   Max(H(I,J),MinDepthFrc)**(0.333333_SP))  &
                   *V(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# else
                   -Cd(I,J)*V(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# endif                          
		          ! dispersion
                          ! (h+eta)(u*\nabla V4 + V4 * \nabla u -v1pp-v2-v3)
                   + Gamma1*MASK9(I,J)*Max(H(I,J),MinDepthFrc)*(         & 
                     U(I,J)*0.5_SP*(V4(I+1,J)-V4(I-1,J))/DX+V(I,J)*0.5_SP*(V4(I,J+1)-V4(I,J-1))/DY &
                     +U4(I,J)*0.5_SP*(V(I+1,J)-V(I-1,J))/DX+V4(I,J)*0.5_SP*(V(I,J+1)-V(I,J-1))/DY  &
                     -Gamma2*MASK9(I,J)*(V1pp(I,J)+V2(I,J)+V3(I,J)) &
                     )    &
                          ! Ht(-V4+V1p) = div(Q)*(V4-V1p)
                    +Gamma1*MASK9(I,J)*((P(I+1,J)-P(I,J))/DX+(Q(I,J+1)-Q(I,J))/DY) &
                      *(V4(I,J)-V1p(I,J))  &
! wavemaker
                   +WaveMaker_Mass(I,J)*V(I,J)
       IF(FRICTION_SPONGE) THEN
          ! note that, compared to wei et al, we used flux. so need multiply D
          SourceY(I,J) = SourceY(I,J) &
                   -CD_4_SPONGE(I,J)*V(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
                    *Depth(I,J)             
       ENDIF

# if defined (DEEP_DRAFT_VESSEL)
          SourceY(I,J) = SourceY(I,J) &
                   -CdVessel_2D(I,J)*V(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J))
# endif

       IF(WaveMakerCurrentBalance)THEN
# if defined (PARALLEL)
	      xmk=(I-Ibeg)*DXg + (iista-1)*DXg
	      ymk=(J-Jbeg)*DYg + (jjsta-1)*DYg
# else
            xmk=(I-Ibeg)*DXg
            ymk=(J-Jbeg)*DYg
# endif
         IF(ABS(xmk-Xc_WK)<Width_WK.AND. &
            ABS(ymk-Yc_WK)<Ywidth_WK/2.0_SP)THEN
            SourceY(I,J) = SourceY(I,J) &
                  -WaveMakerCd*V(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J))
         ENDIF
       ENDIF ! current balance


       IF(BREAKWATER) THEN
          ! note that, compared to wei et al, we used flux. so need multiply D
          SourceY(I,J) = SourceY(I,J) &
                   -CD_BREAKWATER(I,J)*V(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
                    *Depth(I,J)             
       ENDIF

# if defined (METEO)
       IF(WindForce)THEN
          SourceX(I,J)=SourceX(I,J)+MASK_WIND(I,J)*RHO_AW*Cdw*WindU2D(I,J) &
                *SQRT(WindU2D(I,J)*WindU2D(I,J) &
                      + WindV2D(I,J)*WindV2D(I,J))
          SourceY(I,J)=SourceY(I,J)+MASK_WIND(I,J)*RHO_AW*Cdw*WindV2D(I,J) &
                *SQRT(WindU2D(I,J)*WindU2D(I,J) &
                      + WindV2D(I,J)*WindV2D(I,J))
       ENDIF   ! end wind
# endif 


# if defined (MIXING)
       SourceX(I,J) = SourceX(I,J) + 1.0_SP/DX*( &
                   0.5_SP*(nu_smg(I,J)+nu_smg(I+1,J))*1.0_SP/DX*(P(I+1,J)-P(I,J))  &
                 - 0.5_SP*(nu_smg(I,J)+nu_smg(I-1,J))*1.0_SP/DX*(P(I,J)-P(I-1,J)) ) &
               + 0.5_SP/DY*( &
                   0.5_SP*(nu_smg(I,J+1)+nu_smg(I,J))*1.0_SP/DY*(P(I,J+1)-P(I,J)) &
                  -0.5_SP*(nu_smg(I,J-1)+nu_smg(I,J))*1.0_SP/DY*(P(I,J)-P(I,J-1))  ) &   
               + 1.0_SP/DY*( &
                   nu_smg(I,J+1)*0.5_SP/DX*(Q(I+1,J+1)-Q(I-1,J+1)) &
                  -nu_smg(I,J-1)*0.5_SP/DX*(Q(I+1,J-1)-Q(I-1,J-1))  )

       SourceY(I,J) = SourceY(I,J) + 1.0_SP/DY*( &
                   0.5_SP*(nu_smg(I,J)+nu_smg(I,J+1))*1.0_SP/DY*(Q(I,J+1)-Q(I,J))  &
                 - 0.5_SP*(nu_smg(I,J)+nu_smg(I,J-1))*1.0_SP/DY*(Q(I,J)-Q(I,J-1)) ) &
               + 0.5_SP/DX*( &
                   0.5_SP*(nu_smg(I+1,J)+nu_smg(I,J))*1.0_SP/DX*(Q(I+1,J)-Q(I,J)) &
                  -0.5_SP*(nu_smg(I-1,J)+nu_smg(I,J))*1.0_SP/DX*(Q(I,J)-Q(I-1,J))  ) &   
               + 1.0_SP/DX*( &
                   nu_smg(I+1,J)*0.5_SP/DY*(P(I+1,J+1)-P(I+1,J-1)) &
                  -nu_smg(I-1,J)*0.5_SP/DY*(P(I-1,J+1)-P(I-1,J-1))  )

# endif

! eddy viscosity breaking
   ! ykchoi(08.18.2015)
   ! new variable :: WAVEMAKER_VIS
   !IF(VISCOSITY_BREAKING.OR.DIFFUSION_SPONGE)THEN
   IF(VISCOSITY_BREAKING.OR.DIFFUSION_SPONGE.OR.WAVEMAKER_VIS)THEN

     IF(PQ_scheme)THEN

!      it turns out P and Q are not exchanged at processor interface
!      it affects edges, make PQ_scheme=false

       SourceX(I,J) = SourceX(I,J) + 0.5_SP/DX*( &
                       nu_vis(I+1,J)* &
                       1.0_SP/DX*(P(I+2,J)-P(I+1,J)) &
                      -nu_vis(I-1,J)* &
                       1.0_SP/DX*(P(I,J)-P(I-1,J)) ) &
!
                                   + 1.0_SP/DY*( &
                       0.5_SP*(nu_vis(I,J+1)+nu_vis(I,J))* &                 
                       0.5_SP/DY*(P(I,J+1)+P(I+1,J+1)-P(I,J)-P(I+1,J)) &
                      -0.5_SP*(nu_vis(I,J-1)+nu_vis(I,J))* &
                       0.5_SP/DY*(P(I,J)+P(I+1,J)-P(I,J-1)-P(I+1,J-1)) )

       SourceY(I,J) = SourceY(I,J) + 0.5_SP/DY*( &
                       nu_vis(I,J+1)* &
                       1.0_SP/DY*(Q(I,J+2)-Q(I,J+1)) &
                      -nu_vis(I,J-1)* &
                       1.0_SP/DY*(Q(I,J)-Q(I,J-1)) ) &
!
                                   + 1.0_SP/DX*( &
                       0.5_SP*(nu_vis(I+1,J)+nu_vis(I,J))* &                 
                       0.5_SP/DX*(Q(I+1,J)+Q(I+1,J+1)-Q(I,J)-Q(I,J+1)) &
                      -0.5_SP*(nu_vis(I-1,J)+nu_vis(I,J))* &
                       0.5_SP/DX*(Q(I,J)+Q(I,J+1)-Q(I-1,J)-Q(I-1,J+1)) )

     ELSE
       SourceX(I,J) = SourceX(I,J) + 0.5_SP/DX*( &
                      (nu_vis(I+1,J)+nu_vis(I,J)) &
                      *1.0_SP/DX*(HU(I+1,J)-HU(I,J)) &
                     -(nu_vis(I-1,J)+nu_vis(I,J)) &
                      *1.0_SP/DX*(HU(I,J)-HU(I-1,J)) ) &
                                   + 0.5_SP/DY*( &
                      (nu_vis(I,J+1)+nu_vis(I,J)) &
                      *1.0_SP/DY*(HU(I,J+1)-HU(I,J)) &
                     -(nu_vis(I,J-1)+nu_vis(I,J)) &
                      *1.0_SP/DY*(HU(I,J)-HU(I,J-1)) )


                     

       SourceY(I,J) = SourceY(I,J) + 0.5_SP/DX*( &
                      (nu_vis(I+1,J)+nu_vis(I,J)) &
                      *1.0_SP/DX*(HV(I+1,J)-HV(I,J)) &
                     -(nu_vis(I-1,J)+nu_vis(I,J)) &
                      *1.0_SP/DX*(HV(I,J)-HV(I-1,J)) ) &
                                   + 0.5_SP/DY*( &
                      (nu_vis(I,J+1)+nu_vis(I,J)) &
                      *1.0_SP/DY*(HV(I,J+1)-HV(I,J)) &
                     -(nu_vis(I,J-1)+nu_vis(I,J)) &
                      *1.0_SP/DY*(HV(I,J)-HV(I,J-1)) )

     ENDIF ! end pq_scheme


    ENDIF  ! end eddy viscosity breaking
# else

! second order, move the second term to left-hand side

# if defined (ZALPHA)
       SourceX(I,J)=GRAV*(Eta(I,J))*SlopeX(I,J)*MASK(I,J) &
                       ! friction
# if defined (MANNING)
                   -(GRAV*Cd(I,J)**2/  &
                   Max(H(I,J),MinDepthFrc)**(0.333333_SP))  &
                   *U(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# else
                   -Cd(I,J)*U(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# endif
                       ! dispersion
                        ! Ht(+V1p) = div(M)*(-U1p)
                    +Gamma1*MASK9(I,J)*((P(I+1,J)-P(I,J))/DX(I,J)+(Q(I,J+1)-Q(I,J))/DY(I,J)) &
                      *(U4(I,J)-U1p(I,J)) &
                        ! Coriolis
                    +Coriolis(I,J)*0.5_SP*(Q(I,J)+Q(I,J+1))
          

       SourceY(I,J)=GRAV*(Eta(I,J))*SlopeY(I,J)*MASK(I,J) &
                          ! friction
# if defined (MANNING)
                   -(GRAV*Cd(I,J)**2/  &
                   Max(H(I,J),MinDepthFrc)**(0.333333_SP))  &
                   *V(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# else
                   -Cd(I,J)*V(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# endif
                          ! dispersion
                          ! Ht(+V1p) = div(Q)*(-V1p)
                    +Gamma1*MASK9(I,J)*((P(I+1,J)-P(I,J))/DX(I,J)+(Q(I,J+1)-Q(I,J))/DY(I,J)) &
                      *(V4(I,J)-V1p(I,J)) &
                        ! Coriolis
                    -Coriolis(I,J)*0.5_SP*(P(I,J)+P(I+1,J))
# else
       SourceX(I,J)=GRAV*(Eta(I,J))*SlopeX(I,J)*MASK(I,J) &
                       ! friction
# if defined (MANNING)
                   -(GRAV*Cd(I,J)**2/  &
                   Max(H(I,J),MinDepthFrc)**(0.333333_SP))  &
                   *U(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# else
                   -Cd(I,J)*U(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# endif
                       ! dispersion
                        ! Ht(+V1p) = div(M)*(-U1p)
                    +Gamma1*MASK9(I,J)*((P(I+1,J)-P(I,J))/DX(I,J)+(Q(I,J+1)-Q(I,J))/DY(I,J)) &
                      *(-U1p(I,J)) &
                        ! Coriolis
                    +Coriolis(I,J)*0.5_SP*(Q(I,J)+Q(I,J+1))
          

       SourceY(I,J)=GRAV*(Eta(I,J))*SlopeY(I,J)*MASK(I,J) &
                          ! friction
# if defined (MANNING)
                   -(GRAV*Cd(I,J)**2/  &
                   Max(H(I,J),MinDepthFrc)**(0.333333_SP))  &
                   *V(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# else
                   -Cd(I,J)*V(I,J)*SQRT(U(I,J)*U(I,J)+V(I,J)*V(I,J)) &
# endif
                          ! dispersion
                          ! Ht(+V1p) = div(Q)*(-V1p)
                    +Gamma1*MASK9(I,J)*((P(I+1,J)-P(I,J))/DX(I,J)+(Q(I,J+1)-Q(I,J))/DY(I,J)) &
                      *(-V1p(I,J)) &
                        ! Coriolis
                    -Coriolis(I,J)*0.5_SP*(P(I,J)+P(I+1,J))
# endif

# endif

# if !defined (VEGETATION)

# define DIV1X(D,V) D = (V(i+1,j) - V(i-1,j))/(2.0*delx)
# define DIV1Y(D,V) D = (V(i,j+1) - V(i,j-1))/(2.0*dely)
# define DIV2X(D,V) D = (V(i+1,j) + V(i-1,j) - 2*V(i,j))/(delx*delx)
# define DIV2Y(D,V) D = (V(i,j+1) + V(i,j-1) - 2*V(i,j))/(dely*dely)
# define DIVXY(D,V) D = (V(i+1,j+1) - V(i+1,j-1) - V(i-1,j+1) + V(i-1,j-1))/(4*dely*dely)

# if defined (CARTESIAN)
        delx = dx
        dely = dy
# else
        delx = dx(i,j)
        dely = dy(i,j)
#endif
        zdn = -depth(i,j)
        zup = zdn+min(vegetation_height(i,j),max(h(i,j),mindepthfrc))
        fac = 0.5*veg_cd*(veg_bv*hval)*veg_N

        ! Obtain derivatives for h
        DIV1X(hx,h)
        DIV2X(hxx,h)
        DIV1Y(hy,h)
        DIV2Y(hyy,h)
        DIVXY(hxy,h)

        ! Make sure we have the latest derivatives of u
        DIV1X(ux(i,j),u)
        DIV2X(uxx(i,j),u)
        DIV1Y(uy(i,j),u)
        DIVXY(uxy(i,j),u)

        ! Make sure we have the latest derivatives of v
        DIV1X(vx(i,j),u)
        DIV1Y(vy(i,j),v)
        DIV2Y(vyy(i,j),v)
        DIVXY(vxy(i,j),v)

        fricx = veg_integral_x(zdn,zup,npts, &
             u(i,j),v(i,j),alpha_v,beta_v,h(i,j),hx,hy,hxx,hxy,hyy,eta(i,j),&
             vx(i,j), vy(i,j), vyy(i,j), vxy(i,j), ux(i,j),&
             uy(i,j), uxx(i,j), uxy(i,j))
        fricy = veg_integral_y(zdn,zup,npts, &
             u(i,j),v(i,j),alpha_v,beta_v,h(i,j),hx,hy,hxx,hxy,hyy,eta(i,j),&
             vx(i,j), vy(i,j), vyy(i,j), vxy(i,j), ux(i,j),&
             uy(i,j), uxx(i,j), uxy(i,j))

        SourceX(i,j) = SourceX(i,j) + fac*fricx
        SourceY(i,j) = SourceY(i,j) + fac*fricy
# endif

     ENDDO
     ENDDO

# if defined (VESSEL)
      SourceX = SourceX + VesselPressureX
      SourceY = SourceY + VesselPressureY
# endif

# if defined (METEO)
    IF(AirPressure)THEN
      SourceX = SourceX + StormPressureX
      SourceY = SourceY + StormPressureY   
    ENDIF  
# endif

END SUBROUTINE SourceTerms

