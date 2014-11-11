within Components.Units;
package Test
  package Water
    package Variations
      model Test_MB_Model_Casella "Model built to test evaporator's behaviour"

      parameter Real tr = 30 "nominal ramp duration";
      parameter Integer Ntot = 10 "nominal number of nodes";
      parameter Real phin = 150954 "nominal external heat flux";
      parameter Real phip = 0.05 "percent varation of external heat flux";
      parameter Real phit = 4000
          "time of first variation of external heat flux";
      parameter Real wn = 0.05 "nominal inlet mass flow rate";
      parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
      parameter Real wt = 2000
          "time of first variation of inlet mass flow rate";
      parameter Real cmdn = 0.5 "nominal valve's command";
      parameter Real cmdp = 0.05 "percent varation of valve's command";
      parameter Real cmdt = 800 "time of first variation of valve's command";

        MovingBoundary.Test.DHT2MBHT dHT2MBHT(
          Ltot=1,
          Stot=0.725519132873375,
          N=Ntot)
                 annotation (Placement(transformation(
              origin={-24,-16},
              extent={{-10,-10},{10,10}},
              rotation=180)));

        ThermoPower.Water.SourceW sourceW(             h=852450,
          redeclare package Medium = Modelica.Media.Water.StandardWater,
          p0=6000000)
          annotation (Placement(transformation(extent={{-74,-88},{-54,-68}},
                rotation=0)));
        MovingBoundary.Test.MBevaporator mBevaporator(
          Cw=385,
          Ltot=1,
          rhoW=8.93e3,
          hOUT(start=3043000),
          gammaA=3000,
          gammaB=10000,
          gammaC=3000,
          W=0.628,
          A=0.0314159,
          Aw=0.0314159/3,
          TwA(start=510.97 + 50),
          TwB(start=548.79 + 21),
          TwC(start=585.97 + 35),
          Gmean=0.665,
          LB(start=0.4),
          LA(start=0.2),
          usederL=true,
          redeclare package OrganicMedium = Modelica.Media.Water.StandardWater,
          p(start=6000000))
                           annotation (Placement(transformation(extent={{-34,-90},
                  {-8,-64}},  rotation=0)));
        ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
            Medium = Modelica.Media.Water.StandardWater)
          annotation (Placement(transformation(extent={{46,-74},{66,-54}},
                rotation=0)));
        ThermoPower.Water.SinkP sinkP(redeclare package Medium =
              Modelica.Media.Water.StandardWater)
                              annotation (Placement(transformation(extent={{76,
                  -74},{96,-54}}, rotation=0)));
        ThermoPower.Thermal.HeatSource1D heatSource1D(
          L=1,
          omega=1,
          N=Ntot)  annotation (Placement(transformation(extent={{-30,16},{-10,36}},
                rotation=0)));
        Modelica.Blocks.Sources.Constant Pout(k=1e5)
          annotation (Placement(transformation(extent={{50,68},{70,88}}, rotation=
                 0)));
        Modelica.Blocks.Sources.Constant Hin(k=852540)
          annotation (Placement(transformation(extent={{-80,-18},{-60,2}},
                rotation=0)));
        Modelica.Blocks.Sources.Ramp Cmd_var_1(
          height=cmdn*cmdp,
          offset=0,
          startTime=cmdt,
          duration=tr)    annotation (Placement(transformation(extent={{2,-14},{
                  18,-4}}, rotation=0)));
        Modelica.Blocks.Sources.Ramp Cmd_var_2(
          height=-cmdp*cmdn,
          startTime=cmdt + 600,
          duration=tr)          annotation (Placement(transformation(extent={{2,
                  -34},{18,-24}}, rotation=0)));
        Modelica.Blocks.Math.Add3 add3_1 annotation (Placement(transformation(
                extent={{36,-22},{50,-12}}, rotation=0)));
        Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
          annotation (Placement(transformation(extent={{2,4},{18,14}}, rotation=0)));
        Modelica.Blocks.Sources.Ramp W_var_1(
          offset=0,
          height=wn*wp,
          startTime=wt,
          duration=tr)  annotation (Placement(transformation(extent={{-124,-30},{
                  -108,-20}}, rotation=0)));
        Modelica.Blocks.Sources.Ramp W_var_2(
          height=-wp*wn,
          startTime=wt + 800,
          duration=tr)        annotation (Placement(transformation(extent={{-124,
                  -50},{-108,-40}}, rotation=0)));
        Modelica.Blocks.Math.Add3 add3_2 annotation (Placement(transformation(
                extent={{-90,-38},{-76,-28}}, rotation=0)));
        Modelica.Blocks.Sources.Constant W_nom(k=wn)
          annotation (Placement(transformation(extent={{-124,-12},{-108,-2}},
                rotation=0)));
        Modelica.Blocks.Sources.Ramp Phi_var_1(
          offset=0,
          height=phin*phip,
          startTime=phit,
          duration=tr)    annotation (Placement(transformation(extent={{-84,66},{
                  -68,76}}, rotation=0)));
        Modelica.Blocks.Sources.Ramp Phi_var_2(
          height=-phip*phin,
          startTime=phit + 600,
          duration=tr)          annotation (Placement(transformation(extent={{-84,
                  46},{-68,56}}, rotation=0)));
        Modelica.Blocks.Math.Add3 add3_3 annotation (Placement(transformation(
                extent={{-50,58},{-36,68}}, rotation=0)));
        Modelica.Blocks.Sources.Constant Phi_nom(k=phin)
          annotation (Placement(transformation(extent={{-84,84},{-68,94}},
                rotation=0)));
        inner ThermoPower.System system(allowFlowReversal=false)
          annotation (Placement(transformation(extent={{0,74},{20,94}})));
      equation
        connect(mBevaporator.inletCold, sourceW.flange)
          annotation (Line(points={{-34,-77},{-48,-77},{-48,-78},{-54,-78}}));
        connect(valveLin.inlet, mBevaporator.outletCold)
          annotation (Line(points={{46,-64},{26,-64},{26,-77},{-8,-77}}));
        connect(sinkP.flange, valveLin.outlet)
          annotation (Line(points={{76,-64},{70,-64},{66,-64}}));
        connect(Pout.y, sinkP.in_p0) annotation (Line(points={{71,78},{82,78},{82,
                -55.2}}, color={0,0,127}));
        connect(Hin.y, sourceW.in_h) annotation (Line(points={{-59,-8},{-60,-8},{
                -60,-72}}, color={0,0,127}));
        connect(Cmd_var_2.y, add3_1.u3) annotation (Line(points={{18.8,-29},{28.4,
                -29},{28.4,-21},{34.6,-21}}, color={0,0,127}));
        connect(Cmd_var_1.y, add3_1.u2) annotation (Line(points={{18.8,-9},{28,-9},
                {28,-17},{34.6,-17}}, color={0,0,127}));
        connect(add3_1.y, valveLin.cmd) annotation (Line(points={{50.7,-17},{56,
                -17},{56,-56}}, color={0,0,127}));
        connect(Cmd_nom.y, add3_1.u1) annotation (Line(points={{18.8,9},{34.6,9},
                {34.6,-13}}, color={0,0,127}));
        connect(W_var_2.y, add3_2.u3) annotation (Line(points={{-107.2,-45},{
                -97.6,-45},{-97.6,-37},{-91.4,-37}}, color={0,0,127}));
        connect(W_var_1.y, add3_2.u2) annotation (Line(points={{-107.2,-25},{-98,
                -25},{-98,-33},{-91.4,-33}}, color={0,0,127}));
        connect(W_nom.y, add3_2.u1) annotation (Line(points={{-107.2,-7},{-91.4,
                -7},{-91.4,-29}}, color={0,0,127}));
        connect(add3_2.y, sourceW.in_w0) annotation (Line(points={{-75.3,-33},{
                -68,-33},{-68,-72}}, color={0,0,127}));
        connect(Phi_var_2.y,add3_3. u3) annotation (Line(points={{-67.2,51},{
                -57.6,51},{-57.6,59},{-51.4,59}}, color={0,0,127}));
        connect(Phi_var_1.y,add3_3. u2) annotation (Line(points={{-67.2,71},{-58,
                71},{-58,63},{-51.4,63}}, color={0,0,127}));
        connect(Phi_nom.y, add3_3.u1) annotation (Line(points={{-67.2,89},{-51.4,
                89},{-51.4,67}}, color={0,0,127}));
        connect(add3_3.y, heatSource1D.power) annotation (Line(points={{-35.3,63},
                {-20,63},{-20,30}}, color={0,0,127}));
        connect(dHT2MBHT.dHT, heatSource1D.wall) annotation (Line(points={{-23.9,
                -6},{-20,-6},{-20,23}},   color={255,127,0}));
        connect(dHT2MBHT.mh, mBevaporator.mbhtb) annotation (Line(
            points={{-24,-25.8},{-24,-46},{-21,-46},{-21,-71.02}},
            color={95,95,95},
            smooth=Smooth.None));
        annotation (Diagram(graphics),
          experiment(
            StopTime=7000,
            NumberOfIntervals=7000,
            Tolerance=1e-006),
          experimentSetupOutput(equdistant=false));
      end Test_MB_Model_Casella;

      model Test_MBeva
      parameter Real tr = 30 "nominal ramp duration";
      parameter Integer Ntot = 10 "nominal number of nodes";
      parameter Real phin = 150954 "nominal external heat flux";
      parameter Real phip = 0.05 "percent varation of external heat flux";
      parameter Real phit = 4000
          "time of first variation of external heat flux";
      parameter Real wn = 0.05 "nominal inlet mass flow rate";
      parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
      parameter Real wt = 2000
          "time of first variation of inlet mass flow rate";
      parameter Real cmdn = 0.5 "nominal valve's command";
      parameter Real cmdp = 0.05 "percent varation of valve's command";
      parameter Real cmdt = 800 "time of first variation of valve's command";
        HeatExchangers.MovingBoundary.MBeva mBeva(
          redeclare package Medium = ThermoCycle.Media.StandardWater,
          A=0.0314159,
          rho_wall=8.93e3,
          U_SB=3000,
          U_TP=10000,
          Void=0.665,
          dVoid_dp=0,
          dVoid_dh=0,
          U_SH=3000,
          L=1,
          c_wall=385,
          h_EX(start=3043000),
          L_SB(start=0.2),
          TwSB(start=510.97 + 50, displayUnit="K"),
          TwTP(start=548.79 + 21, displayUnit="K"),
          TwSH(start=585.97 + 35, displayUnit="K"),
          L_TP(start=0.4),
          M_tot=9.35E+01,
          p(start=6000000))
          annotation (Placement(transformation(extent={{-36,-50},{10,-14}})));
        ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
          redeclare package Medium = ThermoCycle.Media.StandardWater,
          UseT=false,
          h_0=852450,
          p=6000000)
          annotation (Placement(transformation(extent={{-82,-44},{-62,-24}})));
        MovingBoundary.Test.DHT2MBHT dHT2MBHT1(
          Ltot=1,
          Stot=0.725519132873375,
          N=Ntot)
                 annotation (Placement(transformation(
              origin={-14,32},
              extent={{-10,-10},{10,10}},
              rotation=180)));
        ThermoPower.Thermal.HeatSource1D heatSource1D(
          L=1,
          omega=1,
          N=Ntot)  annotation (Placement(transformation(extent={{-28,74},{-8,94}},
                rotation=0)));
        Modelica.Blocks.Math.Add3 add3_3 annotation (Placement(transformation(
                extent={{-72,106},{-58,116}},
                                            rotation=0)));
        Modelica.Blocks.Sources.Constant Hin(k=852540)
          annotation (Placement(transformation(extent={{-126,36},{-106,56}},
                rotation=0)));
        Modelica.Blocks.Sources.Ramp W_var_1(
          offset=0,
          height=wn*wp,
          startTime=wt,
          duration=tr)  annotation (Placement(transformation(extent={{-166,8},{-150,18}},
                              rotation=0)));
        Modelica.Blocks.Sources.Ramp W_var_2(
          height=-wp*wn,
          startTime=wt + 800,
          duration=tr)        annotation (Placement(transformation(extent={{-166,-12},
                  {-150,-2}},       rotation=0)));
        Modelica.Blocks.Math.Add3 add3_2 annotation (Placement(transformation(
                extent={{-128,-4},{-114,6}},  rotation=0)));
        Modelica.Blocks.Sources.Constant W_nom(k=wn)
          annotation (Placement(transformation(extent={{-166,26},{-150,36}},
                rotation=0)));
        ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
            Medium = Modelica.Media.Water.StandardWater)
          annotation (Placement(transformation(extent={{56,-34},{76,-14}},
                rotation=0)));
        ThermoPower.Water.SinkP sinkP1(
                                      redeclare package Medium =
              Modelica.Media.Water.StandardWater, p0=10000000000)
                              annotation (Placement(transformation(extent={{86,-34},{106,
                  -14}},          rotation=0)));
        Modelica.Blocks.Sources.Ramp Cmd_var_1(
          height=cmdn*cmdp,
          offset=0,
          startTime=cmdt,
          duration=tr)    annotation (Placement(transformation(extent={{16,46},{32,56}},
                           rotation=0)));
        Modelica.Blocks.Sources.Ramp Cmd_var_2(
          height=-cmdp*cmdn,
          startTime=cmdt + 600,
          duration=tr)          annotation (Placement(transformation(extent={{16,26},{
                  32,36}},        rotation=0)));
        Modelica.Blocks.Math.Add3 add3_1 annotation (Placement(transformation(
                extent={{50,38},{64,48}},   rotation=0)));
        Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
          annotation (Placement(transformation(extent={{16,64},{32,74}},
                                                                       rotation=0)));
        Modelica.Blocks.Sources.Constant Pout(k=1e5)
          annotation (Placement(transformation(extent={{60,78},{80,98}}, rotation=
                 0)));
        inner ThermoPower.System system(allowFlowReversal=false)
          annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
        Modelica.Blocks.Sources.Ramp Phi_var_1(
          offset=0,
          height=phin*phip,
          startTime=phit,
          duration=tr)    annotation (Placement(transformation(extent={{-134,104},{
                  -118,114}},
                            rotation=0)));
        Modelica.Blocks.Sources.Ramp Phi_var_2(
          height=-phip*phin,
          startTime=phit + 600,
          duration=tr)          annotation (Placement(transformation(extent={{-124,78},
                  {-108,88}},    rotation=0)));
        Modelica.Blocks.Sources.Constant Phi_nom(k=phin)
          annotation (Placement(transformation(extent={{-150,118},{-134,128}},
                rotation=0)));
      equation
        connect(sourceMdot.flangeB, mBeva.InFlow) annotation (Line(
            points={{-63,-34},{-59.27,-34},{-59.27,-32.36},{-35.54,-32.36}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(add3_3.y,heatSource1D. power) annotation (Line(points={{-57.3,111},{-18,
                111},{-18,88}},     color={0,0,127}));
        connect(dHT2MBHT1.dHT, heatSource1D.wall)
                                                 annotation (Line(points={{-13.9,
                42},{-18,42},{-18,81}},   color={255,127,0}));
        connect(dHT2MBHT1.mh, mBeva.MB_port) annotation (Line(
            points={{-14,22.2},{-14,8},{-11.85,8},{-11.85,-17.6}},
            color={95,95,95},
            smooth=Smooth.None));
        connect(W_var_2.y,add3_2. u3) annotation (Line(points={{-149.2,-7},{-139.6,-7},
                {-139.6,-3},{-129.4,-3}},            color={0,0,127}));
        connect(W_var_1.y,add3_2. u2) annotation (Line(points={{-149.2,13},{-140,13},{
                -140,1},{-129.4,1}},         color={0,0,127}));
        connect(W_nom.y,add3_2. u1) annotation (Line(points={{-149.2,31},{-129.4,31},{
                -129.4,5}},       color={0,0,127}));
        connect(Hin.y, sourceMdot.in_h) annotation (Line(
            points={{-105,46},{-108,46},{-108,44},{-66,44},{-66,-28}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(add3_2.y, sourceMdot.in_Mdot) annotation (Line(
            points={{-113.3,1},{-78,1},{-78,-28}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(sinkP1.flange, valveLin.outlet)
          annotation (Line(points={{86,-24},{80,-24},{76,-24}}));
        connect(mBeva.OutFlow, valveLin.inlet) annotation (Line(
            points={{10,-32},{16,-32},{16,-26},{22,-26},{22,-24},{56,-24}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(Cmd_var_2.y,add3_1. u3) annotation (Line(points={{32.8,31},{42.4,31},{
                42.4,39},{48.6,39}},         color={0,0,127}));
        connect(Cmd_var_1.y,add3_1. u2) annotation (Line(points={{32.8,51},{42,51},{42,
                43},{48.6,43}},       color={0,0,127}));
        connect(add3_1.y, valveLin.cmd) annotation (Line(points={{64.7,43},{66,43},{66,
                -16}},          color={0,0,127}));
        connect(Cmd_nom.y,add3_1. u1) annotation (Line(points={{32.8,69},{48.6,69},{48.6,
                47}},        color={0,0,127}));
        connect(Pout.y, sinkP1.in_p0) annotation (Line(
            points={{81,88},{90,88},{90,-15.2},{92,-15.2}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(Phi_var_2.y,add3_3. u3) annotation (Line(points={{-107.2,83},{-97.6,
                83},{-97.6,107},{-73.4,107}},     color={0,0,127}));
        connect(Phi_var_1.y,add3_3. u2) annotation (Line(points={{-117.2,109},{-98,
                109},{-98,111},{-73.4,111}},
                                          color={0,0,127}));
        connect(Phi_nom.y, add3_3.u1) annotation (Line(points={{-133.2,123},{-73.4,
                123},{-73.4,115}},
                                 color={0,0,127}));
        annotation (Diagram(graphics),
          experiment(StopTime=7000),
          __Dymola_experimentSetupOutput);
      end Test_MBeva;

      model Test_1Deva
        ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot3_2(
          Mdot_0=3.148,
          cp=1907,
          rho=937.952,
          T_0=398.15)
          annotation (Placement(transformation(extent={{58,40},{38,60}})));
        ThermoCycle.Components.Units.HeatExchangers.Hx1DConst eva(
          Mdotnom_sf=3.148,
          Mdotnom_wf=0.3335,
          Mdotconst_wf=false,
          steadystate_h_wf=true,
          steadystate_T_wall=true,
          steadystate_T_sf=false,
          Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
          redeclare package Medium1 = ThermoCycle.Media.Solkatherm_CPSmooth,
          redeclare model Medium1HeatTransferModel =
              ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.VaporQualityDependance,
          Unom_l=4000,
          Unom_tp=4000,
          Unom_v=4000,
          N=30,
          V_sf=0.02,
          V_wf=0.02,
          Unom_sf=15000,
          pstart_wf=888343,
          Tstart_inlet_wf=356.26,
          Tstart_outlet_wf=397.75,
          Tstart_inlet_sf=398.15,
          Tstart_outlet_sf=389.45)
          annotation (Placement(transformation(extent={{-28,2},{8,40}})));
        ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
          Mdot_0=0.3335,
          redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
          p=888343,
          T_0=356.26)
          annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
        ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(
          redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
          h=255110,
          p0=888343)
          annotation (Placement(transformation(extent={{70,-4},{90,16}})));
      equation
        connect(eva.inletSf, source_Cdot3_2.flange) annotation (Line(
            points={{8,30.5},{16,30.5},{16,30},{24,30},{24,49.9},{39.8,49.9}},
            color={255,0,0},
            smooth=Smooth.None));
        connect(sourceMdot.flangeB, eva.inletWf) annotation (Line(
            points={{-71,-20},{-54,-20},{-54,-6},{-42,-6},{-42,11.5},{-28,11.5}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(eva.outletWf, sinkP.flangeB) annotation (Line(
            points={{8,11.5},{36,11.5},{36,14},{64,14},{64,6},{71.6,6}},
            color={0,0,255},
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end Test_1Deva;
    end Variations;

    model Test_MBeva_Complete
    parameter Real tr = 30 "nominal ramp duration";
    parameter Integer Ntot = 10 "nominal number of nodes";
    parameter Real phin = 150954 "nominal external heat flux";
    parameter Real phip = 0.05 "percent varation of external heat flux";
    parameter Real phit = 4000 "time of first variation of external heat flux";
    parameter Real wn = 0.05 "nominal inlet mass flow rate";
    parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
    parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
    parameter Real cmdn = 0.5 "nominal valve's command";
    parameter Real cmdp = 0.05 "percent varation of valve's command";
    parameter Real cmdt = 800 "time of first variation of valve's command";
      ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
        UseT=false,
        h_0=852450,
        Mdot_0=0.05,
        redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
        p=6000000)
        annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
      Modelica.Blocks.Sources.Constant Hin(k=852540)
        annotation (Placement(transformation(extent={{-100,-16},{-80,4}},
              rotation=0)));
      ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
          Medium = CoolProp2Modelica.Media.WaterTPSI_FP)
        annotation (Placement(transformation(extent={{60,-44},{80,-24}},
              rotation=0)));
      ThermoPower.Water.SinkP sinkP1(
                                    redeclare package Medium =
         CoolProp2Modelica.Media.WaterTPSI_FP, p0=10000000000)
                            annotation (Placement(transformation(extent={{90,-44},{110,
                -24}},          rotation=0)));
      Modelica.Blocks.Sources.Constant Pout(k=1e5)
        annotation (Placement(transformation(extent={{132,30},{112,50}},
                                                                       rotation=
               0)));
      inner ThermoPower.System system(allowFlowReversal=false)
        annotation (Placement(transformation(extent={{-100,40},{-60,78}})));
      HeatExchangers.MovingBoundary.MBeva_Complete mBeva_Complete(
        A=0.0314159,
        L=1,
        M_tot=9.35E+01,
        c_wall=385,
        rho_wall=8.93e3,
        TwSB(start=510.97 + 50, displayUnit="K"),
        TwTP(start=548.79 + 21, displayUnit="K"),
        TwSH(start=585.97 + 35, displayUnit="K"),
        Tsf_SU_start=360 + 273.15,
        U_SB=3000,
        U_TP=10000,
        U_SH=3000,
        L_SB(start=0.2),
        L_TP(start=0.4),
        Void=0.665,
        dVoid_dp=0,
        dVoid_dh=0,
        redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
        ETA=1,
        Usf=10000,
        p(start=6000000),
        dTsf_start=313.15,
        h_EX(start=2043000))
        annotation (Placement(transformation(extent={{-38,-42},{10,6}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
        rho=1000,
        Mdot_0=2,
        cp=2046,
        T_0=653.15) annotation (Placement(transformation(extent={{-16,28},{4,48}})));
      Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
        annotation (Placement(transformation(extent={{46,-10},{62,0}},
                                                                     rotation=0)));
    equation
      connect(Hin.y, sourceMdot.in_h) annotation (Line(
          points={{-79,-6},{-70,-6},{-70,-34}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sinkP1.flange, valveLin.outlet)
        annotation (Line(points={{90,-34},{84,-34},{80,-34}}));
      connect(Pout.y, sinkP1.in_p0) annotation (Line(
          points={{111,40},{94,40},{94,-25.2},{96,-25.2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sourceMdot.flangeB, mBeva_Complete.InFlow) annotation (Line(
          points={{-67,-40},{-52,-40},{-52,-33.36},{-37.52,-33.36}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(mBeva_Complete.OutFlow, valveLin.inlet) annotation (Line(
          points={{10,-33.36},{36,-33.36},{36,-34},{60,-34}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(sourceCdot.flange, mBeva_Complete.InFlow_sf) annotation (Line(
          points={{2.2,37.9},{20,37.9},{20,-3.6},{10,-3.6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
          points={{62.8,-5},{70,-5},{70,-26}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
              preserveAspectRatio=true),
                          graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
                100}})),
        experiment(StopTime=1000),
        __Dymola_experimentSetupOutput);
    end Test_MBeva_Complete;

    package ComparisonFV
      model Test_MBeva_Complete_NTU
      parameter Real tr = 30 "nominal ramp duration";
      parameter Integer Ntot = 10 "nominal number of nodes";
      parameter Real phin = 150954 "nominal external heat flux";
      parameter Real phip = 0.05 "percent varation of external heat flux";
      parameter Real phit = 4000
          "time of first variation of external heat flux";
      parameter Real wn = 0.05 "nominal inlet mass flow rate";
      parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
      parameter Real wt = 2000
          "time of first variation of inlet mass flow rate";
      parameter Real cmdn = 0.5 "nominal valve's command";
      parameter Real cmdp = 0.05 "percent varation of valve's command";
      parameter Real cmdt = 800 "time of first variation of valve's command";
        ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
          UseT=false,
          h_0=852450,
          Mdot_0=0.05,
          redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
          p=6000000)
          annotation (Placement(transformation(extent={{-86,-62},{-66,-42}})));
        Modelica.Blocks.Sources.Constant Hin(k=852540)
          annotation (Placement(transformation(extent={{-100,-16},{-80,4}},
                rotation=0)));
        ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
            Medium = CoolProp2Modelica.Media.WaterTPSI_FP)
          annotation (Placement(transformation(extent={{60,-44},{80,-24}},
                rotation=0)));
        ThermoPower.Water.SinkP sinkP1(
                                      redeclare package Medium =
           CoolProp2Modelica.Media.WaterTPSI_FP, p0=10000000000)
                              annotation (Placement(transformation(extent={{90,-44},{110,
                  -24}},          rotation=0)));
        Modelica.Blocks.Sources.Constant Pout(k=1e5)
          annotation (Placement(transformation(extent={{128,14},{108,34}},
                                                                         rotation=
                 0)));
        inner ThermoPower.System system(allowFlowReversal=false)
          annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
       Components.Units.HeatExchangers.MovingBoundary.MBeva_Complete_NTU mBeva_Complete(
          A=0.0314159,
          L=1,
          M_tot=9.35E+01,
          c_wall=385,
          rho_wall=8.93e3,
          TwSB(start=510.97 + 50, displayUnit="K"),
          TwTP(start=548.79 + 21, displayUnit="K"),
          TwSH(start=585.97 + 35, displayUnit="K"),
          Tsf_SU_start=360 + 273.15,
          U_SB=3000,
          U_TP=10000,
          U_SH=3000,
          L_SB(start=0.2),
          L_TP(start=0.4),
          h_EX(start=3043000),
          Void=0.665,
          dVoid_dp=0,
          dVoid_dh=0,
          redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
          Usf=20000,
          ETA=1,
          p(start=6000000),
          dTsf_start=343.15)
          annotation (Placement(transformation(extent={{-38,-42},{10,6}})));
        ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
          rho=1000,
          Mdot_0=2,
          cp=2046,
          T_0=653.15) annotation (Placement(transformation(extent={{2,30},{22,50}})));
        Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
          annotation (Placement(transformation(extent={{26,74},{42,84}},
                                                                       rotation=0)));
      equation
        connect(Hin.y, sourceMdot.in_h) annotation (Line(
            points={{-79,-6},{-70,-6},{-70,-46}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(sinkP1.flange, valveLin.outlet)
          annotation (Line(points={{90,-34},{84,-34},{80,-34}}));
        connect(Pout.y, sinkP1.in_p0) annotation (Line(
            points={{107,24},{94,24},{94,-25.2},{96,-25.2}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(sourceMdot.flangeB, mBeva_Complete.InFlow) annotation (Line(
            points={{-67,-52},{-52,-52},{-52,-33.36},{-37.52,-33.36}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(mBeva_Complete.OutFlow, valveLin.inlet) annotation (Line(
            points={{10,-33.36},{36,-33.36},{36,-34},{60,-34}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(sourceCdot.flange, mBeva_Complete.InFlow_sf) annotation (Line(
            points={{20.2,39.9},{32,39.9},{32,-3.6},{10,-3.6}},
            color={255,0,0},
            smooth=Smooth.None));
        connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
            points={{42.8,79},{70,79},{70,-26}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
                preserveAspectRatio=true),
                            graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
                  100}})),
          experiment(StopTime=1000),
          __Dymola_experimentSetupOutput);
      end Test_MBeva_Complete_NTU;

      model Test_FV
      parameter Real tr = 30 "nominal ramp duration";
      parameter Integer Ntot = 10 "nominal number of nodes";
      parameter Real phin = 150954 "nominal external heat flux";
      parameter Real phip = 0.05 "percent varation of external heat flux";
      parameter Real phit = 4000
          "time of first variation of external heat flux";
      parameter Real wn = 0.05 "nominal inlet mass flow rate";
      parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
      parameter Real wt = 2000
          "time of first variation of inlet mass flow rate";
      parameter Real cmdn = 0.5 "nominal valve's command";
      parameter Real cmdp = 0.05 "percent varation of valve's command";
      parameter Real cmdt = 800 "time of first variation of valve's command";
        ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
          UseT=false,
          h_0=852450,
          Mdot_0=0.05,
          redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
          p=6000000)
          annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
        Modelica.Blocks.Sources.Constant Hin(k=852540)
          annotation (Placement(transformation(extent={{-100,-16},{-80,4}},
                rotation=0)));
        ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
            Medium = CoolProp2Modelica.Media.WaterTPSI_FP)
          annotation (Placement(transformation(extent={{60,-44},{80,-24}},
                rotation=0)));
        ThermoPower.Water.SinkP sinkP1(
                                      redeclare package Medium =
           CoolProp2Modelica.Media.WaterTPSI_FP, p0=10000000000)
                              annotation (Placement(transformation(extent={{90,-44},{110,
                  -24}},          rotation=0)));
        Modelica.Blocks.Sources.Constant Pout(k=1e5)
          annotation (Placement(transformation(extent={{128,14},{108,34}},
                                                                         rotation=
                 0)));
        inner ThermoPower.System system(allowFlowReversal=false)
          annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
       ThermoCycle.Components.Units.HeatExchangers.Hx1DConst FV(
          redeclare package Medium1 = CoolProp2Modelica.Media.WaterTPSI_FP,
          Unom_sf=20000,
          Unom_l=3000,
          Unom_tp=10000,
          Unom_v=3000,
          M_wall=9.35E+01,
          c_wall=385,
          Mdotnom_sf=2,
          Mdotnom_wf=0.05,
          Tstart_inlet_wf=510.97 + 50,
          Tstart_outlet_wf=585.97 + 35,
          Tstart_inlet_sf=360 + 273.15,
          Tstart_outlet_sf=350 + 273.15,
          Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
          V_sf=0.03142,
          V_wf=0.03142,
          A_sf=0.6283,
          A_wf=0.6283,
          pstart_wf=6000000)
          annotation (Placement(transformation(extent={{-38,-44},{10,4}})));

        ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
          rho=1000,
          Mdot_0=2,
          cp=2046,
          T_0=653.15) annotation (Placement(transformation(extent={{2,30},{22,50}})));
        Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
          annotation (Placement(transformation(extent={{26,74},{42,84}},
                                                                       rotation=0)));
      equation
        connect(Hin.y, sourceMdot.in_h) annotation (Line(
            points={{-79,-6},{-70,-6},{-70,-34}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(sinkP1.flange, valveLin.outlet)
          annotation (Line(points={{90,-34},{84,-34},{80,-34}}));
        connect(Pout.y, sinkP1.in_p0) annotation (Line(
            points={{107,24},{94,24},{94,-25.2},{96,-25.2}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
            points={{42.8,79},{70,79},{70,-26}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(sourceMdot.flangeB, FV.inletWf) annotation (Line(
            points={{-67,-40},{-50,-40},{-50,-32},{-38,-32}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(sourceCdot.flange, FV.inletSf) annotation (Line(
            points={{20.2,39.9},{26,39.9},{26,-8},{10,-8}},
            color={255,0,0},
            smooth=Smooth.None));
        connect(FV.outletWf, valveLin.inlet) annotation (Line(
            points={{10,-32},{28,-32},{28,-34},{60,-34}},
            color={0,0,255},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
                preserveAspectRatio=true),
                            graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
                  100}})),
          experiment(StopTime=1000),
          __Dymola_experimentSetupOutput);
      end Test_FV;
    end ComparisonFV;

    model Test_MBeva_2
    parameter Real tr = 30 "nominal ramp duration";
    parameter Integer Ntot = 10 "nominal number of nodes";
    parameter Real phin = 150954 "nominal external heat flux";
    parameter Real phip = 0.05 "percent varation of external heat flux";
    parameter Real phit = 4000 "time of first variation of external heat flux";
    parameter Real wn = 0.05 "nominal inlet mass flow rate";
    parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
    parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
    parameter Real cmdn = 0.5 "nominal valve's command";
    parameter Real cmdp = 0.05 "percent varation of valve's command";
    parameter Real cmdt = 800 "time of first variation of valve's command";
      HeatExchangers.MovingBoundary.MBeva mBeva(
        redeclare package Medium = ThermoCycle.Media.StandardWater,
        A=0.0314159,
        rho_wall=8.93e3,
        U_SB=3000,
        U_TP=10000,
        Void=0.665,
        dVoid_dp=0,
        dVoid_dh=0,
        U_SH=3000,
        L=1,
        c_wall=385,
        h_EX(start=3043000),
        L_SB(start=0.2),
        TwSB(start=510.97 + 50, displayUnit="K"),
        TwTP(start=548.79 + 21, displayUnit="K"),
        TwSH(start=585.97 + 35, displayUnit="K"),
        L_TP(start=0.4),
        M_tot=9.35E+01,
        p(start=6000000))
        annotation (Placement(transformation(extent={{-36,-50},{10,-14}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
        redeclare package Medium = ThermoCycle.Media.StandardWater,
        UseT=false,
        h_0=852450,
        Mdot_0=0.05,
        p=6000000)
        annotation (Placement(transformation(extent={{-80,-46},{-60,-26}})));
      MovingBoundary.Test.DHT2MBHT dHT2MBHT1(
        Ltot=1,
        Stot=0.725519132873375,
        N=Ntot)
               annotation (Placement(transformation(
            origin={-10,24},
            extent={{-10,-10},{10,10}},
            rotation=180)));
      ThermoPower.Thermal.HeatSource1D heatSource1D(
        L=1,
        omega=1,
        N=Ntot)  annotation (Placement(transformation(extent={{-52,64},{-32,84}},
              rotation=0)));
      Modelica.Blocks.Sources.Constant Hin(k=852540)
        annotation (Placement(transformation(extent={{-104,-18},{-84,2}},
              rotation=0)));
      ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
          Medium = Modelica.Media.Water.StandardWater)
        annotation (Placement(transformation(extent={{56,-34},{76,-14}},
              rotation=0)));
      ThermoPower.Water.SinkP sinkP1(
                                    redeclare package Medium =
            Modelica.Media.Water.StandardWater, p0=10000000000)
                            annotation (Placement(transformation(extent={{86,-34},{106,
                -14}},          rotation=0)));
      Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
        annotation (Placement(transformation(extent={{16,64},{32,74}},
                                                                     rotation=0)));
      Modelica.Blocks.Sources.Constant Pout(k=1e5)
        annotation (Placement(transformation(extent={{60,78},{80,98}}, rotation=
               0)));
      inner ThermoPower.System system(allowFlowReversal=false)
        annotation (Placement(transformation(extent={{-82,40},{-62,60}})));
      Modelica.Blocks.Sources.Constant Phi_nom(k=phin)
        annotation (Placement(transformation(extent={{-78,84},{-62,94}},
              rotation=0)));
    equation
      connect(sourceMdot.flangeB, mBeva.InFlow) annotation (Line(
          points={{-61,-36},{-59.27,-36},{-59.27,-32.36},{-35.54,-32.36}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(dHT2MBHT1.dHT, heatSource1D.wall)
                                               annotation (Line(points={{-9.9,34},
              {-10,34},{-10,46},{-12,46},{-12,58},{-42,58},{-42,71}},
                                        color={255,127,0}));
      connect(dHT2MBHT1.mh, mBeva.MB_port) annotation (Line(
          points={{-10,14.2},{-10,8},{-11.85,8},{-11.85,-17.6}},
          color={95,95,95},
          smooth=Smooth.None));
      connect(Hin.y, sourceMdot.in_h) annotation (Line(
          points={{-83,-8},{-64,-8},{-64,-30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sinkP1.flange, valveLin.outlet)
        annotation (Line(points={{86,-24},{80,-24},{76,-24}}));
      connect(mBeva.OutFlow, valveLin.inlet) annotation (Line(
          points={{10,-32},{16,-32},{16,-26},{22,-26},{22,-24},{56,-24}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(Pout.y, sinkP1.in_p0) annotation (Line(
          points={{81,88},{90,88},{90,-15.2},{92,-15.2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
          points={{32.8,69},{66,69},{66,-16}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Phi_nom.y, heatSource1D.power) annotation (Line(
          points={{-61.2,89},{-40.6,89},{-40.6,78},{-42,78}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics),
        experiment(StopTime=7000),
        __Dymola_experimentSetupOutput);
    end Test_MBeva_2;

    model Test_MB_Model_Casella_2 "Model built to test evaporator's behaviour"

    parameter Real tr = 30 "nominal ramp duration";
    parameter Integer Ntot = 10 "nominal number of nodes";
    parameter Real phin = 150954 "nominal external heat flux";
    parameter Real phip = 0.05 "percent varation of external heat flux";
    parameter Real phit = 4000 "time of first variation of external heat flux";
    parameter Real wn = 0.05 "nominal inlet mass flow rate";
    parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
    parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
    parameter Real cmdn = 0.5 "nominal valve's command";
    parameter Real cmdp = 0.05 "percent varation of valve's command";
    parameter Real cmdt = 800 "time of first variation of valve's command";

      MovingBoundary.Test.DHT2MBHT dHT2MBHT(
        Ltot=1,
        Stot=0.725519132873375,
        N=Ntot)
               annotation (Placement(transformation(
            origin={-24,-16},
            extent={{-10,-10},{10,10}},
            rotation=180)));

      ThermoPower.Water.SourceW sourceW(             h=852450,
        redeclare package Medium = Modelica.Media.Water.StandardWater,
        p0=6000000)
        annotation (Placement(transformation(extent={{-74,-88},{-54,-68}},
              rotation=0)));
      MovingBoundary.Test.MBevaporator mBevaporator(
        Cw=385,
        Ltot=1,
        rhoW=8.93e3,
        hOUT(start=3043000),
        gammaA=3000,
        gammaB=10000,
        gammaC=3000,
        W=0.628,
        A=0.0314159,
        Aw=0.0314159/3,
        TwA(start=510.97 + 50),
        TwB(start=548.79 + 21),
        TwC(start=585.97 + 35),
        Gmean=0.665,
        LB(start=0.4),
        LA(start=0.2),
        redeclare package OrganicMedium = Modelica.Media.Water.StandardWater,
        usederL=false,
        p(start=6000000))
                         annotation (Placement(transformation(extent={{-34,-90},
                {-8,-64}},  rotation=0)));
      ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
          Medium = Modelica.Media.Water.StandardWater)
        annotation (Placement(transformation(extent={{46,-74},{66,-54}},
              rotation=0)));
      ThermoPower.Water.SinkP sinkP(redeclare package Medium =
            Modelica.Media.Water.StandardWater)
                            annotation (Placement(transformation(extent={{76,
                -74},{96,-54}}, rotation=0)));
      ThermoPower.Thermal.HeatSource1D heatSource1D(
        L=1,
        omega=1,
        N=Ntot)  annotation (Placement(transformation(extent={{-30,16},{-10,36}},
              rotation=0)));
      Modelica.Blocks.Sources.Constant Pout(k=1e5)
        annotation (Placement(transformation(extent={{50,68},{70,88}}, rotation=
               0)));
      Modelica.Blocks.Sources.Constant Hin(k=852540)
        annotation (Placement(transformation(extent={{-114,-34},{-94,-14}},
              rotation=0)));
      Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
        annotation (Placement(transformation(extent={{2,4},{18,14}}, rotation=0)));
      Modelica.Blocks.Sources.Constant W_nom(k=wn)
        annotation (Placement(transformation(extent={{-124,-56},{-108,-46}},
              rotation=0)));
      Modelica.Blocks.Sources.Constant Phi_nom(k=phin)
        annotation (Placement(transformation(extent={{-84,84},{-68,94}},
              rotation=0)));
      inner ThermoPower.System system(allowFlowReversal=false)
        annotation (Placement(transformation(extent={{0,74},{20,94}})));
    equation
      connect(mBevaporator.inletCold, sourceW.flange)
        annotation (Line(points={{-34,-77},{-48,-77},{-48,-78},{-54,-78}}));
      connect(valveLin.inlet, mBevaporator.outletCold)
        annotation (Line(points={{46,-64},{26,-64},{26,-77},{-8,-77}}));
      connect(sinkP.flange, valveLin.outlet)
        annotation (Line(points={{76,-64},{70,-64},{66,-64}}));
      connect(Pout.y, sinkP.in_p0) annotation (Line(points={{71,78},{82,78},{82,
              -55.2}}, color={0,0,127}));
      connect(Hin.y, sourceW.in_h) annotation (Line(points={{-93,-24},{-60,-24},{
              -60,-72}}, color={0,0,127}));
      connect(dHT2MBHT.dHT, heatSource1D.wall) annotation (Line(points={{-23.9,
              -6},{-20,-6},{-20,23}},   color={255,127,0}));
      connect(dHT2MBHT.mh, mBevaporator.mbhtb) annotation (Line(
          points={{-24,-25.8},{-24,-46},{-21,-46},{-21,-71.02}},
          color={95,95,95},
          smooth=Smooth.None));
      connect(W_nom.y, sourceW.in_w0) annotation (Line(
          points={{-107.2,-51},{-68,-51},{-68,-72}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Phi_nom.y, heatSource1D.power) annotation (Line(
          points={{-67.2,89},{-20,89},{-20,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
          points={{18.8,9},{56,9},{56,-56}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics),
        experiment(
          StopTime=7000,
          NumberOfIntervals=7000,
          Tolerance=1e-006),
        experimentSetupOutput(equdistant=false));
    end Test_MB_Model_Casella_2;

    model Test_Evaporator
      ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot3_2(
        Mdot_0=2,
        T_0=653.15,
        cp=2046,
        rho=1000)
        annotation (Placement(transformation(extent={{58,32},{38,52}})));
      ThermoCycle.Components.Units.HeatExchangers.Hx1DConst eva(
        Mdotnom_sf=3.148,
        Mdotconst_wf=false,
        steadystate_h_wf=true,
        steadystate_T_wall=true,
        steadystate_T_sf=false,
        Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
        redeclare model Medium1HeatTransferModel =
            ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.VaporQualityDependance,
        N=30,
        V_sf=0.02,
        V_wf=0.02,
        redeclare package Medium1 = CoolProp2Modelica.Media.WaterTPSI_FP,
        Unom_sf=10000,
        Unom_l=3000,
        Unom_tp=10000,
        Unom_v=3000,
        Mdotnom_wf=0.05,
        pstart_wf=6000000,
        Tstart_inlet_wf=503.15,
        Tstart_outlet_wf=718.15,
        Tstart_outlet_sf=718.15)
        annotation (Placement(transformation(extent={{-28,2},{8,40}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
        redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
        UseT=false,
        Mdot_0=0.05,
        p=6000000,
        T_0=356.26)
        annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
      Modelica.Blocks.Sources.Constant Hin(k=852540)
        annotation (Placement(transformation(extent={{-104,2},{-84,22}},
              rotation=0)));
      ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
          Medium = CoolProp2Modelica.Media.WaterTPSI_FP)
        annotation (Placement(transformation(extent={{50,-16},{70,4}},
              rotation=0)));
      ThermoPower.Water.SinkP sinkP1(
                                    redeclare package Medium =
         CoolProp2Modelica.Media.WaterTPSI_FP, p0=10000000000)
                            annotation (Placement(transformation(extent={{80,-16},
                {100,4}},       rotation=0)));
      Modelica.Blocks.Sources.Constant Pout(k=1e5)
        annotation (Placement(transformation(extent={{114,14},{94,34}},rotation=
               0)));
      Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
        annotation (Placement(transformation(extent={{40,12},{56,22}},
                                                                     rotation=0)));
      inner ThermoPower.System system(allowFlowReversal=false)
        annotation (Placement(transformation(extent={{-90,50},{-50,88}})));
    equation
      connect(eva.inletSf, source_Cdot3_2.flange) annotation (Line(
          points={{8,30.5},{16,30.5},{16,30},{24,30},{24,41.9},{39.8,41.9}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(sourceMdot.flangeB, eva.inletWf) annotation (Line(
          points={{-71,-20},{-54,-20},{-54,10},{-42,10},{-42,11.5},{-28,11.5}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(Hin.y, sourceMdot.in_h) annotation (Line(
          points={{-83,12},{-74,12},{-74,-14}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sinkP1.flange,valveLin. outlet)
        annotation (Line(points={{80,-6},{74,-6},{70,-6}}));
      connect(Pout.y,sinkP1. in_p0) annotation (Line(
          points={{93,24},{84,24},{84,2.8},{86,2.8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Cmd_nom.y,valveLin. cmd) annotation (Line(
          points={{56.8,17},{60,17},{60,2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(eva.outletWf, valveLin.inlet) annotation (Line(
          points={{8,11.5},{18,11.5},{18,10},{30,10},{30,-6},{50,-6}},
          color={0,0,255},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end Test_Evaporator;

    model Calculations
    replaceable package Medium = CoolProp2Modelica.Media.WaterTPSI_FP constrainedby
        Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching = true);

    parameter Modelica.SIunits.SpecificEnthalpy h_ex = 3043000;
    parameter Modelica.SIunits.Pressure p_ex = 60e5;
    Modelica.SIunits.Temperature T_ex;

    equation
    T_ex = Medium.temperature_ph(p_ex,h_ex);

    end Calculations;
  end Water;

  package Solkatherm
    model Test_Eva1D
      ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot3_2(
        Mdot_0=3.148,
        cp=1907,
        rho=937.952,
        T_0=398.15)
        annotation (Placement(transformation(extent={{78,50},{58,70}})));
      ThermoCycle.Components.Units.HeatExchangers.Hx1DConst eva(
        Mdotnom_sf=3.148,
        Mdotnom_wf=0.3335,
        Mdotconst_wf=false,
        steadystate_h_wf=true,
        steadystate_T_wall=true,
        steadystate_T_sf=false,
        Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
        redeclare package Medium1 = ThermoCycle.Media.Solkatherm_CPSmooth,
        redeclare model Medium1HeatTransferModel =
            ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.VaporQualityDependance,
        Unom_l=4000,
        Unom_tp=4000,
        Unom_v=4000,
        N=30,
        V_sf=0.02,
        V_wf=0.02,
        Unom_sf=15000,
        pstart_wf=888343,
        Tstart_inlet_wf=356.26,
        Tstart_outlet_wf=397.75,
        Tstart_inlet_sf=398.15,
        Tstart_outlet_sf=389.45)
        annotation (Placement(transformation(extent={{-34,12},{2,50}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
        Mdot_0=0.3335,
        redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
        p=888343,
        T_0=356.26)
        annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(
        redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
        h=255110,
        p0=888343)
        annotation (Placement(transformation(extent={{58,-30},{78,-10}})));
    equation
      connect(eva.inletSf, source_Cdot3_2.flange) annotation (Line(
          points={{2,40.5},{40,40.5},{40,60},{48,60},{48,59.9},{59.8,59.9}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(sourceMdot.flangeB, eva.inletWf) annotation (Line(
          points={{-71,0},{-60,0},{-60,21.5},{-34,21.5}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(eva.outletWf, sinkP.flangeB) annotation (Line(
          points={{2,21.5},{28,21.5},{28,-18},{56,-18},{56,-20},{59.6,-20}},
          color={0,0,255},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end Test_Eva1D;

    model Test_MB_Complete
      ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
        UseT=false,
        h_0=852450,
        Mdot_0=0.3335,
        redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
        p=6000000)
        annotation (Placement(transformation(extent={{-122,-40},{-102,-20}})));
      HeatExchangers.MovingBoundary.MBeva_Complete mBeva_Complete(
        rho_wall=8.93e3,
        L_SB(start=0.2),
        Void=0.665,
        dVoid_dp=0,
        dVoid_dh=0,
        ETA=1,
        M_tot=69,
        c_wall=500,
        TwSB(start=116 + 273.15, displayUnit="K"),
        Tsf_SU_start=125 + 273.15,
        h_EX(start=254493),
        redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
        Mdotnom=0.3335,
        TwTP(start=116 + 273.15, displayUnit="K"),
        TwSH(start=116 + 273.15, displayUnit="K"),
        Usf=2000,
        U_SB=2000,
        U_TP=2000,
        U_SH=2000,
        L_TP(start=0.2),
        A=0.0000192,
        L=1000,
        p(start=888343),
        dTsf_start=283.15)
        annotation (Placement(transformation(extent={{-76,-30},{-28,18}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
        Mdot_0=3.148,
        cp=1907,
        rho=937.952,
        T_0=398.15) annotation (Placement(transformation(extent={{-34,40},{-14,60}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(
        redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
        h=255110,
        p0=888343)
        annotation (Placement(transformation(extent={{68,-36},{88,-16}})));
      ORCNext.Components.PdropHP     pdropHP(
        UseHomotopy=false,
        constinit=false,
        use_rho_nom=true)
        annotation (Placement(transformation(extent={{10,-36},{30,-16}})));
    equation
      connect(sourceMdot.flangeB,mBeva_Complete. InFlow) annotation (Line(
          points={{-103,-30},{-88,-30},{-88,-21.36},{-75.52,-21.36}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(sourceCdot.flange,mBeva_Complete. InFlow_sf) annotation (Line(
          points={{-15.8,49.9},{-4,49.9},{-4,8.4},{-28,8.4}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(mBeva_Complete.OutFlow, pdropHP.InFlow) annotation (Line(
          points={{-28,-21.36},{0,-21.36},{0,-26},{11,-26}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(pdropHP.OutFlow, sinkP.flangeB) annotation (Line(
          points={{29,-26},{69.6,-26}},
          color={0,0,255},
          smooth=Smooth.None));
      annotation (
        Diagram(graphics),
        experiment(StopTime=50, Tolerance=1e-007),
        __Dymola_experimentSetupOutput);
    end Test_MB_Complete;

    model Test_MBeva
    parameter Integer N = 10;
      HeatExchangers.MovingBoundary.MBeva mBeva(
        rho_wall=8.93e3,
        U_SB=3000,
        Void=0.665,
        dVoid_dp=0,
        dVoid_dh=0,
        U_SH=3000,
        redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
        M_tot=69,
        c_wall=500,
        TwSB(start=100 + 273.15, displayUnit="K"),
        TwTP(start=100 + 273.15, displayUnit="K"),
        TwSH(start=100 + 273.15, displayUnit="K"),
        U_TP=3000,
        h_EX(start=254493),
        A=0.0000192,
        L=1042,
        L_SB(start=400),
        L_TP(start=600),
        p(start=888343))
        annotation (Placement(transformation(extent={{-26,-40},{20,-4}})));
      MovingBoundary.Test.DHT2MBHT dHT2MBHT1(
        N=N,
        Stot=16.18,
        Ltot=1042)
               annotation (Placement(transformation(
            origin={-4,42},
            extent={{-10,-10},{10,10}},
            rotation=180)));
      ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
        redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
        Mdot_0=0.3335,
        p=888343,
        T_0=356.26)
        annotation (Placement(transformation(extent={{-86,-54},{-66,-34}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
          Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
                                                       p0=888343)
        annotation (Placement(transformation(extent={{66,-32},{86,-12}})));
      ThermoCycle.Components.FluidFlow.Pipes.Flow1DConst flow1DConst(
        N=N,
        V=0.02,
        Mdotnom=3.148,
        Unom=15000,
        Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
        Tstart_inlet=398.15,
        Tstart_outlet=389.45)
        annotation (Placement(transformation(extent={{14,94},{-26,66}})));

      ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
        Mdot_0=3.148,
        T_0=398.15,
        cp=1907,
        rho=937.952)
        annotation (Placement(transformation(extent={{74,70},{54,90}})));
    equation
      connect(dHT2MBHT1.mh,mBeva. MB_port) annotation (Line(
          points={{-4,32.2},{-4,6},{-1.85,6},{-1.85,-7.6}},
          color={95,95,95},
          smooth=Smooth.None));
      connect(sourceMdot.flangeB, mBeva.InFlow) annotation (Line(
          points={{-67,-44},{-54,-44},{-54,-22.36},{-25.54,-22.36}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(mBeva.OutFlow, sinkP.flangeB) annotation (Line(
          points={{20,-22},{67.6,-22}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(flow1DConst.Wall_int, dHT2MBHT1.dHT) annotation (Line(
          points={{-6,73},{-3.9,73},{-3.9,52}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(sourceCdot.flange, flow1DConst.flange_Cdot) annotation (Line(
          points={{55.8,79.9},{34.9,79.9},{34.9,80},{14,80}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end Test_MBeva;
  end Solkatherm;

  model Test_MBeva_Complete_NTU
  parameter Real tr = 30 "nominal ramp duration";
  parameter Integer Ntot = 10 "nominal number of nodes";
  parameter Real phin = 150954 "nominal external heat flux";
  parameter Real phip = 0.05 "percent varation of external heat flux";
  parameter Real phit = 4000 "time of first variation of external heat flux";
  parameter Real wn = 0.05 "nominal inlet mass flow rate";
  parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
  parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
  parameter Real cmdn = 0.5 "nominal valve's command";
  parameter Real cmdp = 0.05 "percent varation of valve's command";
  parameter Real cmdt = 800 "time of first variation of valve's command";
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      UseT=false,
      h_0=852450,
      Mdot_0=0.05,
      redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
      p=6000000)
      annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-100,-16},{-80,4}},
            rotation=0)));
    ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
        Medium = CoolProp2Modelica.Media.WaterTPSI_FP)
      annotation (Placement(transformation(extent={{60,-44},{80,-24}},
            rotation=0)));
    ThermoPower.Water.SinkP sinkP1(
                                  redeclare package Medium =
       CoolProp2Modelica.Media.WaterTPSI_FP, p0=10000000000)
                          annotation (Placement(transformation(extent={{90,-44},{110,
              -24}},          rotation=0)));
    Modelica.Blocks.Sources.Constant Pout(k=1e5)
      annotation (Placement(transformation(extent={{128,14},{108,34}},
                                                                     rotation=
             0)));
    inner ThermoPower.System system(allowFlowReversal=false)
      annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
   Components.Units.HeatExchangers.MovingBoundary.MBeva_Complete_NTU mBeva_Complete(
      A=0.0314159,
      L=1,
      M_tot=9.35E+01,
      c_wall=385,
      rho_wall=8.93e3,
      TwSB(start=510.97 + 50, displayUnit="K"),
      TwTP(start=548.79 + 21, displayUnit="K"),
      TwSH(start=585.97 + 35, displayUnit="K"),
      Tsf_SU_start=360 + 273.15,
      U_SB=3000,
      U_TP=10000,
      U_SH=3000,
      L_SB(start=0.2),
      L_TP(start=0.4),
      h_EX(start=3043000),
      Void=0.665,
      dVoid_dp=0,
      dVoid_dh=0,
      redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
      Usf=20000,
      ETA=1,
      p(start=6000000),
      dTsf_start=343.15)
      annotation (Placement(transformation(extent={{-38,-42},{10,6}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
      rho=1000,
      Mdot_0=2,
      cp=2046,
      T_0=653.15) annotation (Placement(transformation(extent={{2,30},{22,50}})));
    Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
      annotation (Placement(transformation(extent={{26,74},{42,84}},
                                                                   rotation=0)));
  equation
    connect(Hin.y, sourceMdot.in_h) annotation (Line(
        points={{-79,-6},{-70,-6},{-70,-34}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sinkP1.flange, valveLin.outlet)
      annotation (Line(points={{90,-34},{84,-34},{80,-34}}));
    connect(Pout.y, sinkP1.in_p0) annotation (Line(
        points={{107,24},{94,24},{94,-25.2},{96,-25.2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, mBeva_Complete.InFlow) annotation (Line(
        points={{-67,-40},{-52,-40},{-52,-33.36},{-37.52,-33.36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(mBeva_Complete.OutFlow, valveLin.inlet) annotation (Line(
        points={{10,-33.36},{36,-33.36},{36,-34},{60,-34}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceCdot.flange, mBeva_Complete.InFlow_sf) annotation (Line(
        points={{20.2,39.9},{32,39.9},{32,-3.6},{10,-3.6}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
        points={{42.8,79},{70,79},{70,-26}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
            preserveAspectRatio=false),
                        graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
              100}})),
      experiment(StopTime=1000),
      __Dymola_experimentSetupOutput);
  end Test_MBeva_Complete_NTU;

  model Test_MBeva_Complete_NTU_2
  parameter Real tr = 30 "nominal ramp duration";
  parameter Integer Ntot = 10 "nominal number of nodes";
  parameter Real phin = 150954 "nominal external heat flux";
  parameter Real phip = 0.05 "percent varation of external heat flux";
  parameter Real phit = 4000 "time of first variation of external heat flux";
  parameter Real wn = 0.05 "nominal inlet mass flow rate";
  parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
  parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
  parameter Real cmdn = 0.5 "nominal valve's command";
  parameter Real cmdp = 0.05 "percent varation of valve's command";
  parameter Real cmdt = 800 "time of first variation of valve's command";
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      UseT=false,
      h_0=852450,
      Mdot_0=0.05,
      redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
      p=6000000)
      annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-100,-16},{-80,4}},
            rotation=0)));
    ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
        Medium = CoolProp2Modelica.Media.WaterTPSI_FP)
      annotation (Placement(transformation(extent={{60,-44},{80,-24}},
            rotation=0)));
    ThermoPower.Water.SinkP sinkP1(
                                  redeclare package Medium =
       CoolProp2Modelica.Media.WaterTPSI_FP, p0=10000000000)
                          annotation (Placement(transformation(extent={{90,-44},{110,
              -24}},          rotation=0)));
    Modelica.Blocks.Sources.Constant Pout(k=1e5)
      annotation (Placement(transformation(extent={{128,14},{108,34}},
                                                                     rotation=
             0)));
    inner ThermoPower.System system(allowFlowReversal=false)
      annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
   Components.Units.HeatExchangers.MovingBoundary.MBeva_Complete_NTU_2 mBeva_Complete(
      A=0.0314159,
      L=1,
      M_tot=9.35E+01,
      c_wall=385,
      rho_wall=8.93e3,
      TwSB(start=510.97 + 50, displayUnit="K"),
      TwTP(start=548.79 + 21, displayUnit="K"),
      TwSH(start=585.97 + 35, displayUnit="K"),
      Tsf_SU_start=360 + 273.15,
      U_SB=3000,
      U_TP=10000,
      U_SH=3000,
      L_SB(start=0.2),
      L_TP(start=0.4),
      h_EX(start=3043000),
      Void=0.665,
      dVoid_dp=0,
      dVoid_dh=0,
      redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
      Usf=20000,
      ETA=1,
      p(start=6000000),
      dTsf_start=343.15)
      annotation (Placement(transformation(extent={{-38,-42},{10,6}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
      rho=1000,
      Mdot_0=2,
      cp=2046,
      T_0=653.15) annotation (Placement(transformation(extent={{2,30},{22,50}})));
    Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
      annotation (Placement(transformation(extent={{26,74},{42,84}},
                                                                   rotation=0)));
  equation
    connect(Hin.y, sourceMdot.in_h) annotation (Line(
        points={{-79,-6},{-70,-6},{-70,-34}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sinkP1.flange, valveLin.outlet)
      annotation (Line(points={{90,-34},{84,-34},{80,-34}}));
    connect(Pout.y, sinkP1.in_p0) annotation (Line(
        points={{107,24},{94,24},{94,-25.2},{96,-25.2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, mBeva_Complete.InFlow) annotation (Line(
        points={{-67,-40},{-52,-40},{-52,-33.36},{-37.52,-33.36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(mBeva_Complete.OutFlow, valveLin.inlet) annotation (Line(
        points={{10,-33.36},{36,-33.36},{36,-34},{60,-34}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceCdot.flange, mBeva_Complete.InFlow_sf) annotation (Line(
        points={{20.2,39.9},{32,39.9},{32,-3.6},{10,-3.6}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
        points={{42.8,79},{70,79},{70,-26}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
            preserveAspectRatio=false),
                        graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
              100}})),
      experiment(StopTime=1000),
      __Dymola_experimentSetupOutput);
  end Test_MBeva_Complete_NTU_2;

  model Test_MBeva
  parameter Real tr = 30 "nominal ramp duration";
  parameter Integer Ntot = 10 "nominal number of nodes";
  parameter Real phin = 150954 "nominal external heat flux";
  parameter Real phip = 0.05 "percent varation of external heat flux";
  parameter Real phit = 4000 "time of first variation of external heat flux";
  parameter Real wn = 0.05 "nominal inlet mass flow rate";
  parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
  parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
  parameter Real cmdn = 0.5 "nominal valve's command";
  parameter Real cmdp = 0.05 "percent varation of valve's command";
  parameter Real cmdt = 800 "time of first variation of valve's command";
    HeatExchangers.MovingBoundary.MBeva mBeva(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      A=0.0314159,
      rho_wall=8.93e3,
      U_SB=3000,
      U_TP=10000,
      Void=0.665,
      dVoid_dp=0,
      dVoid_dh=0,
      U_SH=3000,
      L=1,
      c_wall=385,
      h_EX(start=3043000),
      L_SB(start=0.2),
      TwSB(start=510.97 + 50, displayUnit="K"),
      TwTP(start=548.79 + 21, displayUnit="K"),
      TwSH(start=585.97 + 35, displayUnit="K"),
      L_TP(start=0.4),
      M_tot=9.35E+01,
      p(start=6000000))
      annotation (Placement(transformation(extent={{-36,-50},{10,-14}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      UseT=false,
      h_0=852450,
      p=6000000)
      annotation (Placement(transformation(extent={{-82,-44},{-62,-24}})));
    MovingBoundary.Test.DHT2MBHT dHT2MBHT1(
      Ltot=1,
      Stot=0.725519132873375,
      N=Ntot)
             annotation (Placement(transformation(
          origin={-14,32},
          extent={{-10,-10},{10,10}},
          rotation=180)));
    ThermoPower.Thermal.HeatSource1D heatSource1D(
      L=1,
      omega=1,
      N=Ntot)  annotation (Placement(transformation(extent={{-28,74},{-8,94}},
            rotation=0)));
    Modelica.Blocks.Math.Add3 add3_3 annotation (Placement(transformation(
            extent={{-72,106},{-58,116}},
                                        rotation=0)));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-126,36},{-106,56}},
            rotation=0)));
    Modelica.Blocks.Sources.Ramp W_var_1(
      offset=0,
      height=wn*wp,
      startTime=wt,
      duration=tr)  annotation (Placement(transformation(extent={{-166,8},{-150,18}},
                          rotation=0)));
    Modelica.Blocks.Sources.Ramp W_var_2(
      height=-wp*wn,
      startTime=wt + 800,
      duration=tr)        annotation (Placement(transformation(extent={{-166,-12},
              {-150,-2}},       rotation=0)));
    Modelica.Blocks.Math.Add3 add3_2 annotation (Placement(transformation(
            extent={{-128,-4},{-114,6}},  rotation=0)));
    Modelica.Blocks.Sources.Constant W_nom(k=wn)
      annotation (Placement(transformation(extent={{-166,26},{-150,36}},
            rotation=0)));
    ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
        Medium = Modelica.Media.Water.StandardWater)
      annotation (Placement(transformation(extent={{56,-34},{76,-14}},
            rotation=0)));
    ThermoPower.Water.SinkP sinkP1(
                                  redeclare package Medium =
          Modelica.Media.Water.StandardWater, p0=10000000000)
                          annotation (Placement(transformation(extent={{86,-34},{106,
              -14}},          rotation=0)));
    Modelica.Blocks.Sources.Ramp Cmd_var_1(
      height=cmdn*cmdp,
      offset=0,
      startTime=cmdt,
      duration=tr)    annotation (Placement(transformation(extent={{16,46},{32,56}},
                       rotation=0)));
    Modelica.Blocks.Sources.Ramp Cmd_var_2(
      height=-cmdp*cmdn,
      startTime=cmdt + 600,
      duration=tr)          annotation (Placement(transformation(extent={{16,26},{
              32,36}},        rotation=0)));
    Modelica.Blocks.Math.Add3 add3_1 annotation (Placement(transformation(
            extent={{50,38},{64,48}},   rotation=0)));
    Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
      annotation (Placement(transformation(extent={{16,64},{32,74}},
                                                                   rotation=0)));
    Modelica.Blocks.Sources.Constant Pout(k=1e5)
      annotation (Placement(transformation(extent={{60,78},{80,98}}, rotation=
             0)));
    inner ThermoPower.System system(allowFlowReversal=false)
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Sources.Ramp Phi_var_1(
      offset=0,
      height=phin*phip,
      startTime=phit,
      duration=tr)    annotation (Placement(transformation(extent={{-134,104},{
              -118,114}},
                        rotation=0)));
    Modelica.Blocks.Sources.Ramp Phi_var_2(
      height=-phip*phin,
      startTime=phit + 600,
      duration=tr)          annotation (Placement(transformation(extent={{-124,78},
              {-108,88}},    rotation=0)));
    Modelica.Blocks.Sources.Constant Phi_nom(k=phin)
      annotation (Placement(transformation(extent={{-150,118},{-134,128}},
            rotation=0)));
  equation
    connect(sourceMdot.flangeB, mBeva.InFlow) annotation (Line(
        points={{-63,-34},{-59.27,-34},{-59.27,-32.36},{-35.54,-32.36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(add3_3.y,heatSource1D. power) annotation (Line(points={{-57.3,111},{-18,
            111},{-18,88}},     color={0,0,127}));
    connect(dHT2MBHT1.dHT, heatSource1D.wall)
                                             annotation (Line(points={{-13.9,42},
            {-18,42},{-18,81}},       color={255,127,0}));
    connect(dHT2MBHT1.mh, mBeva.MB_port) annotation (Line(
        points={{-14,22.2},{-14,8},{-11.85,8},{-11.85,-17.6}},
        color={95,95,95},
        smooth=Smooth.None));
    connect(W_var_2.y,add3_2. u3) annotation (Line(points={{-149.2,-7},{-139.6,-7},
            {-139.6,-3},{-129.4,-3}},            color={0,0,127}));
    connect(W_var_1.y,add3_2. u2) annotation (Line(points={{-149.2,13},{-140,13},{
            -140,1},{-129.4,1}},         color={0,0,127}));
    connect(W_nom.y,add3_2. u1) annotation (Line(points={{-149.2,31},{-129.4,31},{
            -129.4,5}},       color={0,0,127}));
    connect(Hin.y, sourceMdot.in_h) annotation (Line(
        points={{-105,46},{-108,46},{-108,44},{-66,44},{-66,-28}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add3_2.y, sourceMdot.in_Mdot) annotation (Line(
        points={{-113.3,1},{-78,1},{-78,-28}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sinkP1.flange, valveLin.outlet)
      annotation (Line(points={{86,-24},{80,-24},{76,-24}}));
    connect(mBeva.OutFlow, valveLin.inlet) annotation (Line(
        points={{10,-32},{16,-32},{16,-26},{22,-26},{22,-24},{56,-24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(Cmd_var_2.y,add3_1. u3) annotation (Line(points={{32.8,31},{42.4,31},{
            42.4,39},{48.6,39}},         color={0,0,127}));
    connect(Cmd_var_1.y,add3_1. u2) annotation (Line(points={{32.8,51},{42,51},{42,
            43},{48.6,43}},       color={0,0,127}));
    connect(add3_1.y, valveLin.cmd) annotation (Line(points={{64.7,43},{66,43},{66,
            -16}},          color={0,0,127}));
    connect(Cmd_nom.y,add3_1. u1) annotation (Line(points={{32.8,69},{48.6,69},{48.6,
            47}},        color={0,0,127}));
    connect(Pout.y, sinkP1.in_p0) annotation (Line(
        points={{81,88},{90,88},{90,-15.2},{92,-15.2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Phi_var_2.y,add3_3. u3) annotation (Line(points={{-107.2,83},{-97.6,
            83},{-97.6,107},{-73.4,107}},     color={0,0,127}));
    connect(Phi_var_1.y,add3_3. u2) annotation (Line(points={{-117.2,109},{-98,
            109},{-98,111},{-73.4,111}},
                                      color={0,0,127}));
    connect(Phi_nom.y, add3_3.u1) annotation (Line(points={{-133.2,123},{-73.4,
            123},{-73.4,115}},
                             color={0,0,127}));
    annotation (Diagram(graphics),
      experiment(StopTime=7000),
      __Dymola_experimentSetupOutput);
  end Test_MBeva;

  model Test_MB_Model_Casella "Model built to test evaporator's behaviour"

  parameter Real tr = 30 "nominal ramp duration";
  parameter Integer Ntot = 10 "nominal number of nodes";
  parameter Real phin = 150954 "nominal external heat flux";
  parameter Real phip = 0.05 "percent varation of external heat flux";
  parameter Real phit = 4000 "time of first variation of external heat flux";
  parameter Real wn = 0.05 "nominal inlet mass flow rate";
  parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
  parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
  parameter Real cmdn = 0.5 "nominal valve's command";
  parameter Real cmdp = 0.05 "percent varation of valve's command";
  parameter Real cmdt = 800 "time of first variation of valve's command";

    MovingBoundary.Test.DHT2MBHT dHT2MBHT(
      Ltot=1,
      Stot=0.725519132873375,
      N=Ntot)
             annotation (Placement(transformation(
          origin={-24,-16},
          extent={{-10,-10},{10,10}},
          rotation=180)));

    ThermoPower.Water.SourceW sourceW(             h=852450,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
      p0=6000000)
      annotation (Placement(transformation(extent={{-74,-88},{-54,-68}},
            rotation=0)));
    MovingBoundary.Test.MBevaporator mBevaporator(
      Cw=385,
      Ltot=1,
      rhoW=8.93e3,
      hOUT(start=3043000),
      gammaA=3000,
      gammaB=10000,
      gammaC=3000,
      W=0.628,
      A=0.0314159,
      Aw=0.0314159/3,
      TwA(start=510.97 + 50),
      TwB(start=548.79 + 21),
      TwC(start=585.97 + 35),
      Gmean=0.665,
      LB(start=0.4),
      LA(start=0.2),
      usederL=true,
      redeclare package OrganicMedium = Modelica.Media.Water.StandardWater,
      p(start=6000000))
                       annotation (Placement(transformation(extent={{-34,-90},
              {-8,-64}},  rotation=0)));
    ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
        Medium = Modelica.Media.Water.StandardWater)
      annotation (Placement(transformation(extent={{46,-74},{66,-54}},
            rotation=0)));
    ThermoPower.Water.SinkP sinkP(redeclare package Medium =
          Modelica.Media.Water.StandardWater)
                          annotation (Placement(transformation(extent={{76,
              -74},{96,-54}}, rotation=0)));
    ThermoPower.Thermal.HeatSource1D heatSource1D(
      L=1,
      omega=1,
      N=Ntot)  annotation (Placement(transformation(extent={{-30,16},{-10,36}},
            rotation=0)));
    Modelica.Blocks.Sources.Constant Pout(k=1e5)
      annotation (Placement(transformation(extent={{50,68},{70,88}}, rotation=
             0)));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-80,-18},{-60,2}},
            rotation=0)));
    Modelica.Blocks.Sources.Ramp Cmd_var_1(
      height=cmdn*cmdp,
      offset=0,
      startTime=cmdt,
      duration=tr)    annotation (Placement(transformation(extent={{2,-14},{
              18,-4}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp Cmd_var_2(
      height=-cmdp*cmdn,
      startTime=cmdt + 600,
      duration=tr)          annotation (Placement(transformation(extent={{2,
              -34},{18,-24}}, rotation=0)));
    Modelica.Blocks.Math.Add3 add3_1 annotation (Placement(transformation(
            extent={{36,-22},{50,-12}}, rotation=0)));
    Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
      annotation (Placement(transformation(extent={{2,4},{18,14}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp W_var_1(
      offset=0,
      height=wn*wp,
      startTime=wt,
      duration=tr)  annotation (Placement(transformation(extent={{-124,-30},{
              -108,-20}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp W_var_2(
      height=-wp*wn,
      startTime=wt + 800,
      duration=tr)        annotation (Placement(transformation(extent={{-124,
              -50},{-108,-40}}, rotation=0)));
    Modelica.Blocks.Math.Add3 add3_2 annotation (Placement(transformation(
            extent={{-90,-38},{-76,-28}}, rotation=0)));
    Modelica.Blocks.Sources.Constant W_nom(k=wn)
      annotation (Placement(transformation(extent={{-124,-12},{-108,-2}},
            rotation=0)));
    Modelica.Blocks.Sources.Ramp Phi_var_1(
      offset=0,
      height=phin*phip,
      startTime=phit,
      duration=tr)    annotation (Placement(transformation(extent={{-84,66},{
              -68,76}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp Phi_var_2(
      height=-phip*phin,
      startTime=phit + 600,
      duration=tr)          annotation (Placement(transformation(extent={{-84,
              46},{-68,56}}, rotation=0)));
    Modelica.Blocks.Math.Add3 add3_3 annotation (Placement(transformation(
            extent={{-50,58},{-36,68}}, rotation=0)));
    Modelica.Blocks.Sources.Constant Phi_nom(k=phin)
      annotation (Placement(transformation(extent={{-84,84},{-68,94}},
            rotation=0)));
    inner ThermoPower.System system(allowFlowReversal=false)
      annotation (Placement(transformation(extent={{0,74},{20,94}})));
  equation
    connect(mBevaporator.inletCold, sourceW.flange)
      annotation (Line(points={{-34,-77},{-48,-77},{-48,-78},{-54,-78}}));
    connect(valveLin.inlet, mBevaporator.outletCold)
      annotation (Line(points={{46,-64},{26,-64},{26,-77},{-8,-77}}));
    connect(sinkP.flange, valveLin.outlet)
      annotation (Line(points={{76,-64},{70,-64},{66,-64}}));
    connect(Pout.y, sinkP.in_p0) annotation (Line(points={{71,78},{82,78},{82,
            -55.2}}, color={0,0,127}));
    connect(Hin.y, sourceW.in_h) annotation (Line(points={{-59,-8},{-60,-8},{
            -60,-72}}, color={0,0,127}));
    connect(Cmd_var_2.y, add3_1.u3) annotation (Line(points={{18.8,-29},{28.4,
            -29},{28.4,-21},{34.6,-21}}, color={0,0,127}));
    connect(Cmd_var_1.y, add3_1.u2) annotation (Line(points={{18.8,-9},{28,-9},
            {28,-17},{34.6,-17}}, color={0,0,127}));
    connect(add3_1.y, valveLin.cmd) annotation (Line(points={{50.7,-17},{56,
            -17},{56,-56}}, color={0,0,127}));
    connect(Cmd_nom.y, add3_1.u1) annotation (Line(points={{18.8,9},{34.6,9},
            {34.6,-13}}, color={0,0,127}));
    connect(W_var_2.y, add3_2.u3) annotation (Line(points={{-107.2,-45},{
            -97.6,-45},{-97.6,-37},{-91.4,-37}}, color={0,0,127}));
    connect(W_var_1.y, add3_2.u2) annotation (Line(points={{-107.2,-25},{-98,
            -25},{-98,-33},{-91.4,-33}}, color={0,0,127}));
    connect(W_nom.y, add3_2.u1) annotation (Line(points={{-107.2,-7},{-91.4,
            -7},{-91.4,-29}}, color={0,0,127}));
    connect(add3_2.y, sourceW.in_w0) annotation (Line(points={{-75.3,-33},{
            -68,-33},{-68,-72}}, color={0,0,127}));
    connect(Phi_var_2.y,add3_3. u3) annotation (Line(points={{-67.2,51},{
            -57.6,51},{-57.6,59},{-51.4,59}}, color={0,0,127}));
    connect(Phi_var_1.y,add3_3. u2) annotation (Line(points={{-67.2,71},{-58,
            71},{-58,63},{-51.4,63}}, color={0,0,127}));
    connect(Phi_nom.y, add3_3.u1) annotation (Line(points={{-67.2,89},{-51.4,
            89},{-51.4,67}}, color={0,0,127}));
    connect(add3_3.y, heatSource1D.power) annotation (Line(points={{-35.3,63},
            {-20,63},{-20,30}}, color={0,0,127}));
    connect(dHT2MBHT.dHT, heatSource1D.wall) annotation (Line(points={{-23.9,
            -6},{-20,-6},{-20,23}},   color={255,127,0}));
    connect(dHT2MBHT.mh, mBevaporator.mbhtb) annotation (Line(
        points={{-24,-25.8},{-24,-46},{-21,-46},{-21,-71.02}},
        color={95,95,95},
        smooth=Smooth.None));
    annotation (Diagram(graphics),
      experiment(
        StopTime=7000,
        NumberOfIntervals=7000,
        Tolerance=1e-006),
      experimentSetupOutput(equdistant=false));
  end Test_MB_Model_Casella;

  model Test_MBeva_Complete
  parameter Real tr = 30 "nominal ramp duration";
  parameter Integer Ntot = 10 "nominal number of nodes";
  parameter Real phin = 150954 "nominal external heat flux";
  parameter Real phip = 0.05 "percent varation of external heat flux";
  parameter Real phit = 4000 "time of first variation of external heat flux";
  parameter Real wn = 0.05 "nominal inlet mass flow rate";
  parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
  parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
  parameter Real cmdn = 0.5 "nominal valve's command";
  parameter Real cmdp = 0.05 "percent varation of valve's command";
  parameter Real cmdt = 800 "time of first variation of valve's command";
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      UseT=false,
      h_0=852450,
      Mdot_0=0.05,
      redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
      p=6000000)
      annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-100,-16},{-80,4}},
            rotation=0)));
    ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
        Medium = CoolProp2Modelica.Media.WaterTPSI_FP)
      annotation (Placement(transformation(extent={{60,-44},{80,-24}},
            rotation=0)));
    ThermoPower.Water.SinkP sinkP1(
                                  redeclare package Medium =
       CoolProp2Modelica.Media.WaterTPSI_FP, p0=10000000000)
                          annotation (Placement(transformation(extent={{90,-44},{110,
              -24}},          rotation=0)));
    Modelica.Blocks.Sources.Constant Pout(k=1e5)
      annotation (Placement(transformation(extent={{128,14},{108,34}},
                                                                     rotation=
             0)));
    inner ThermoPower.System system(allowFlowReversal=false)
      annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
    HeatExchangers.MovingBoundary.MBeva_Complete mBeva_Complete(
      A=0.0314159,
      L=1,
      M_tot=9.35E+01,
      c_wall=385,
      rho_wall=8.93e3,
      TwSB(start=510.97 + 50, displayUnit="K"),
      TwTP(start=548.79 + 21, displayUnit="K"),
      TwSH(start=585.97 + 35, displayUnit="K"),
      Tsf_SU_start=360 + 273.15,
      U_SB=3000,
      U_TP=10000,
      U_SH=3000,
      L_SB(start=0.2),
      L_TP(start=0.4),
      h_EX(start=3043000),
      Void=0.665,
      dVoid_dp=0,
      dVoid_dh=0,
      redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
      Usf=20000,
      p(start=6000000),
      dTsf_start=343.15,
      ETA=1)
      annotation (Placement(transformation(extent={{-38,-42},{10,6}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
      rho=1000,
      Mdot_0=2,
      cp=2046,
      T_0=653.15) annotation (Placement(transformation(extent={{2,30},{22,50}})));
    Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
      annotation (Placement(transformation(extent={{26,74},{42,84}},
                                                                   rotation=0)));
  equation
    connect(Hin.y, sourceMdot.in_h) annotation (Line(
        points={{-79,-6},{-70,-6},{-70,-34}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sinkP1.flange, valveLin.outlet)
      annotation (Line(points={{90,-34},{84,-34},{80,-34}}));
    connect(Pout.y, sinkP1.in_p0) annotation (Line(
        points={{107,24},{94,24},{94,-25.2},{96,-25.2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, mBeva_Complete.InFlow) annotation (Line(
        points={{-67,-40},{-52,-40},{-52,-33.36},{-37.52,-33.36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(mBeva_Complete.OutFlow, valveLin.inlet) annotation (Line(
        points={{10,-33.36},{36,-33.36},{36,-34},{60,-34}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceCdot.flange, mBeva_Complete.InFlow_sf) annotation (Line(
        points={{20.2,39.9},{32,39.9},{32,-3.6},{10,-3.6}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
        points={{42.8,79},{70,79},{70,-26}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
            preserveAspectRatio=true),
                        graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
              100}})),
      experiment(StopTime=1000),
      __Dymola_experimentSetupOutput);
  end Test_MBeva_Complete;

  model Test_MBeva_Complete_NTU_WaterCoolProp
  parameter Real tr = 30 "nominal ramp duration";
  parameter Integer Ntot = 10 "nominal number of nodes";
  parameter Real phin = 150954 "nominal external heat flux";
  parameter Real phip = 0.05 "percent varation of external heat flux";
  parameter Real phit = 4000 "time of first variation of external heat flux";
  parameter Real wn = 0.05 "nominal inlet mass flow rate";
  parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
  parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
  parameter Real cmdn = 0.5 "nominal valve's command";
  parameter Real cmdp = 0.05 "percent varation of valve's command";
  parameter Real cmdt = 800 "time of first variation of valve's command";
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      UseT=false,
      h_0=852450,
      Mdot_0=0.05,
      redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
      p=6000000)
      annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-100,-16},{-80,4}},
            rotation=0)));
    ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
        Medium = CoolProp2Modelica.Media.WaterTPSI_FP)
      annotation (Placement(transformation(extent={{60,-44},{80,-24}},
            rotation=0)));
    ThermoPower.Water.SinkP sinkP1(
                                  redeclare package Medium =
       CoolProp2Modelica.Media.WaterTPSI_FP, p0=10000000000)
                          annotation (Placement(transformation(extent={{90,-44},{110,
              -24}},          rotation=0)));
    Modelica.Blocks.Sources.Constant Pout(k=1e5)
      annotation (Placement(transformation(extent={{128,14},{108,34}},
                                                                     rotation=
             0)));
    inner ThermoPower.System system(allowFlowReversal=false)
      annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
   Components.Units.HeatExchangers.MovingBoundary.MBeva_Complete_NTU mBeva_Complete(
      A=0.0314159,
      L=1,
      M_tot=9.35E+01,
      c_wall=385,
      rho_wall=8.93e3,
      TwSB(start=510.97 + 50, displayUnit="K"),
      TwTP(start=548.79 + 21, displayUnit="K"),
      TwSH(start=585.97 + 35, displayUnit="K"),
      Tsf_SU_start=360 + 273.15,
      U_SB=3000,
      U_TP=10000,
      U_SH=3000,
      L_SB(start=0.2),
      L_TP(start=0.4),
      h_EX(start=3043000),
      Void=0.665,
      dVoid_dp=0,
      dVoid_dh=0,
      redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
      Usf=20000,
      ETA=1,
      p(start=6000000),
      dTsf_start=343.15)
      annotation (Placement(transformation(extent={{-38,-42},{10,6}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
      rho=1000,
      Mdot_0=2,
      cp=2046,
      T_0=653.15) annotation (Placement(transformation(extent={{2,30},{22,50}})));
    Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
      annotation (Placement(transformation(extent={{26,74},{42,84}},
                                                                   rotation=0)));
  equation
    connect(Hin.y, sourceMdot.in_h) annotation (Line(
        points={{-79,-6},{-70,-6},{-70,-34}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sinkP1.flange, valveLin.outlet)
      annotation (Line(points={{90,-34},{84,-34},{80,-34}}));
    connect(Pout.y, sinkP1.in_p0) annotation (Line(
        points={{107,24},{94,24},{94,-25.2},{96,-25.2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, mBeva_Complete.InFlow) annotation (Line(
        points={{-67,-40},{-52,-40},{-52,-33.36},{-37.52,-33.36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(mBeva_Complete.OutFlow, valveLin.inlet) annotation (Line(
        points={{10,-33.36},{36,-33.36},{36,-34},{60,-34}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceCdot.flange, mBeva_Complete.InFlow_sf) annotation (Line(
        points={{20.2,39.9},{32,39.9},{32,-3.6},{10,-3.6}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
        points={{42.8,79},{70,79},{70,-26}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
            preserveAspectRatio=true),
                        graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
              100}})),
      experiment(StopTime=1000),
      __Dymola_experimentSetupOutput);
  end Test_MBeva_Complete_NTU_WaterCoolProp;

  model Test_MBeva_2
  parameter Real tr = 30 "nominal ramp duration";
  parameter Integer Ntot = 10 "nominal number of nodes";
  parameter Real phin = 150954 "nominal external heat flux";
  parameter Real phip = 0.05 "percent varation of external heat flux";
  parameter Real phit = 4000 "time of first variation of external heat flux";
  parameter Real wn = 0.05 "nominal inlet mass flow rate";
  parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
  parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
  parameter Real cmdn = 0.5 "nominal valve's command";
  parameter Real cmdp = 0.05 "percent varation of valve's command";
  parameter Real cmdt = 800 "time of first variation of valve's command";
    HeatExchangers.MovingBoundary.MBeva mBeva(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      A=0.0314159,
      rho_wall=8.93e3,
      U_SB=3000,
      U_TP=10000,
      Void=0.665,
      dVoid_dp=0,
      dVoid_dh=0,
      U_SH=3000,
      L=1,
      c_wall=385,
      h_EX(start=3043000),
      L_SB(start=0.2),
      TwSB(start=510.97 + 50, displayUnit="K"),
      TwTP(start=548.79 + 21, displayUnit="K"),
      TwSH(start=585.97 + 35, displayUnit="K"),
      L_TP(start=0.4),
      M_tot=9.35E+01,
      p(start=6000000))
      annotation (Placement(transformation(extent={{-36,-50},{10,-14}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      UseT=false,
      h_0=852450,
      Mdot_0=0.05,
      p=6000000)
      annotation (Placement(transformation(extent={{-82,-44},{-62,-24}})));
    MovingBoundary.Test.DHT2MBHT dHT2MBHT1(
      Ltot=1,
      Stot=0.725519132873375,
      N=Ntot)
             annotation (Placement(transformation(
          origin={-14,32},
          extent={{-10,-10},{10,10}},
          rotation=180)));
    ThermoPower.Thermal.HeatSource1D heatSource1D(
      L=1,
      omega=1,
      N=Ntot)  annotation (Placement(transformation(extent={{-52,64},{-32,84}},
            rotation=0)));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-156,-16},{-136,4}},
            rotation=0)));
    ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
        Medium = Modelica.Media.Water.StandardWater)
      annotation (Placement(transformation(extent={{56,-34},{76,-14}},
            rotation=0)));
    ThermoPower.Water.SinkP sinkP1(
                                  redeclare package Medium =
          Modelica.Media.Water.StandardWater, p0=10000000000)
                          annotation (Placement(transformation(extent={{86,-34},{106,
              -14}},          rotation=0)));
    Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
      annotation (Placement(transformation(extent={{16,64},{32,74}},
                                                                   rotation=0)));
    Modelica.Blocks.Sources.Constant Pout(k=1e5)
      annotation (Placement(transformation(extent={{60,78},{80,98}}, rotation=
             0)));
    inner ThermoPower.System system(allowFlowReversal=false)
      annotation (Placement(transformation(extent={{-92,36},{-72,56}})));
    Modelica.Blocks.Sources.Constant Phi_nom(k=phin)
      annotation (Placement(transformation(extent={{-150,118},{-134,128}},
            rotation=0)));
  equation
    connect(sourceMdot.flangeB, mBeva.InFlow) annotation (Line(
        points={{-63,-34},{-59.27,-34},{-59.27,-32.36},{-35.54,-32.36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(dHT2MBHT1.dHT, heatSource1D.wall)
                                             annotation (Line(points={{-13.9,42},
            {-42,42},{-42,71}},       color={255,127,0}));
    connect(dHT2MBHT1.mh, mBeva.MB_port) annotation (Line(
        points={{-14,22.2},{-14,8},{-11.85,8},{-11.85,-17.6}},
        color={95,95,95},
        smooth=Smooth.None));
    connect(Hin.y, sourceMdot.in_h) annotation (Line(
        points={{-135,-6},{-66,-6},{-66,-28}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sinkP1.flange, valveLin.outlet)
      annotation (Line(points={{86,-24},{80,-24},{76,-24}}));
    connect(mBeva.OutFlow, valveLin.inlet) annotation (Line(
        points={{10,-32},{16,-32},{16,-26},{22,-26},{22,-24},{56,-24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(Pout.y, sinkP1.in_p0) annotation (Line(
        points={{81,88},{90,88},{90,-15.2},{92,-15.2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
        points={{32.8,69},{66,69},{66,-16}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Phi_nom.y, heatSource1D.power) annotation (Line(
        points={{-133.2,123},{-86.6,123},{-86.6,78},{-42,78}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(graphics),
      experiment(StopTime=7000),
      __Dymola_experimentSetupOutput);
  end Test_MBeva_2;

  model Test_MB_Model_Casella_2 "Model built to test evaporator's behaviour"

  parameter Real tr = 30 "nominal ramp duration";
  parameter Integer Ntot = 10 "nominal number of nodes";
  parameter Real phin = 150954 "nominal external heat flux";
  parameter Real phip = 0.05 "percent varation of external heat flux";
  parameter Real phit = 4000 "time of first variation of external heat flux";
  parameter Real wn = 0.05 "nominal inlet mass flow rate";
  parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
  parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
  parameter Real cmdn = 0.5 "nominal valve's command";
  parameter Real cmdp = 0.05 "percent varation of valve's command";
  parameter Real cmdt = 800 "time of first variation of valve's command";

    MovingBoundary.Test.DHT2MBHT dHT2MBHT(
      Ltot=1,
      Stot=0.725519132873375,
      N=Ntot)
             annotation (Placement(transformation(
          origin={-24,-16},
          extent={{-10,-10},{10,10}},
          rotation=180)));

    ThermoPower.Water.SourceW sourceW(             h=852450,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
      p0=6000000)
      annotation (Placement(transformation(extent={{-74,-88},{-54,-68}},
            rotation=0)));
    MovingBoundary.Test.MBevaporator mBevaporator(
      Cw=385,
      Ltot=1,
      rhoW=8.93e3,
      hOUT(start=3043000),
      gammaA=3000,
      gammaB=10000,
      gammaC=3000,
      W=0.628,
      A=0.0314159,
      Aw=0.0314159/3,
      TwA(start=510.97 + 50),
      TwB(start=548.79 + 21),
      TwC(start=585.97 + 35),
      Gmean=0.665,
      LB(start=0.4),
      LA(start=0.2),
      redeclare package OrganicMedium = Modelica.Media.Water.StandardWater,
      usederL=false,
      p(start=6000000))
                       annotation (Placement(transformation(extent={{-34,-90},
              {-8,-64}},  rotation=0)));
    ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package
        Medium = Modelica.Media.Water.StandardWater)
      annotation (Placement(transformation(extent={{46,-74},{66,-54}},
            rotation=0)));
    ThermoPower.Water.SinkP sinkP(redeclare package Medium =
          Modelica.Media.Water.StandardWater)
                          annotation (Placement(transformation(extent={{76,
              -74},{96,-54}}, rotation=0)));
    ThermoPower.Thermal.HeatSource1D heatSource1D(
      L=1,
      omega=1,
      N=Ntot)  annotation (Placement(transformation(extent={{-30,16},{-10,36}},
            rotation=0)));
    Modelica.Blocks.Sources.Constant Pout(k=1e5)
      annotation (Placement(transformation(extent={{50,68},{70,88}}, rotation=
             0)));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-114,-34},{-94,-14}},
            rotation=0)));
    Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
      annotation (Placement(transformation(extent={{2,4},{18,14}}, rotation=0)));
    Modelica.Blocks.Sources.Constant W_nom(k=wn)
      annotation (Placement(transformation(extent={{-124,-56},{-108,-46}},
            rotation=0)));
    Modelica.Blocks.Sources.Constant Phi_nom(k=phin)
      annotation (Placement(transformation(extent={{-84,84},{-68,94}},
            rotation=0)));
    inner ThermoPower.System system(allowFlowReversal=false)
      annotation (Placement(transformation(extent={{0,74},{20,94}})));
  equation
    connect(mBevaporator.inletCold, sourceW.flange)
      annotation (Line(points={{-34,-77},{-48,-77},{-48,-78},{-54,-78}}));
    connect(valveLin.inlet, mBevaporator.outletCold)
      annotation (Line(points={{46,-64},{26,-64},{26,-77},{-8,-77}}));
    connect(sinkP.flange, valveLin.outlet)
      annotation (Line(points={{76,-64},{70,-64},{66,-64}}));
    connect(Pout.y, sinkP.in_p0) annotation (Line(points={{71,78},{82,78},{82,
            -55.2}}, color={0,0,127}));
    connect(Hin.y, sourceW.in_h) annotation (Line(points={{-93,-24},{-60,-24},{
            -60,-72}}, color={0,0,127}));
    connect(dHT2MBHT.dHT, heatSource1D.wall) annotation (Line(points={{-23.9,
            -6},{-20,-6},{-20,23}},   color={255,127,0}));
    connect(dHT2MBHT.mh, mBevaporator.mbhtb) annotation (Line(
        points={{-24,-25.8},{-24,-46},{-21,-46},{-21,-71.02}},
        color={95,95,95},
        smooth=Smooth.None));
    connect(W_nom.y, sourceW.in_w0) annotation (Line(
        points={{-107.2,-51},{-68,-51},{-68,-72}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Phi_nom.y, heatSource1D.power) annotation (Line(
        points={{-67.2,89},{-20,89},{-20,30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
        points={{18.8,9},{56,9},{56,-56}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(graphics),
      experiment(
        StopTime=7000,
        NumberOfIntervals=7000,
        Tolerance=1e-006),
      experimentSetupOutput(equdistant=false));
  end Test_MB_Model_Casella_2;

  model Test_vector_summary_Class

  parameter Integer N = 3;
  parameter Modelica.SIunits.Temperature T_1;
  parameter Modelica.SIunits.Temperature T_2;
  parameter Modelica.SIunits.Temperature T_3;
  Modelica.SIunits.Temperature T_wall[1,N];

  equation
  T_wall = [T_1,T_2,T_3];

  end Test_vector_summary_Class;

  model Comparison1DHx

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      UseT=false,
      h_0=852450,
      Mdot_0=0.3335,
      redeclare package Medium = ThermoCycle.Media.SES36_CP,
      p=6000000)
      annotation (Placement(transformation(extent={{-122,-40},{-102,-20}})));
    ThermoCycle.Components.Units.HeatExchangers.MBeva mBeva_Complete(
      rho_wall=8.93e3,
      L_SB(start=0.2),
      Void=0.665,
      dVoid_dp=0,
      dVoid_dh=0,
      ETA=1,
      M_tot=69,
      c_wall=500,
      TwSB(start=116 + 273.15, displayUnit="K"),
      Tsf_SU_start=125 + 273.15,
      h_EX(start=254493),
      TwTP(start=116 + 273.15, displayUnit="K"),
      TwSH(start=116 + 273.15, displayUnit="K"),
      Usf=2000,
      U_SB=2000,
      U_TP=2000,
      U_SH=2000,
      L_TP(start=0.2),
      A=0.0000192,
      L=1000,
      redeclare package Medium = ThermoCycle.Media.SES36_CP,
      p(start=888343),
      dTsf_start=283.15)
      annotation (Placement(transformation(extent={{-66,-30},{-18,18}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
      Mdot_0=3.148,
      cp=1907,
      rho=937.952,
      T_0=398.15) annotation (Placement(transformation(extent={{-34,40},{-14,60}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(
      h=255110,
      redeclare package Medium = ThermoCycle.Media.SES36_CP,
      p0=888343)
      annotation (Placement(transformation(extent={{68,-36},{88,-16}})));
    ORCNext.Components.PdropHP     pdropHP(
      UseHomotopy=false,
      constinit=false,
      use_rho_nom=true)
      annotation (Placement(transformation(extent={{22,-28},{42,-8}})));
  equation
    connect(sourceMdot.flangeB,mBeva_Complete. InFlow) annotation (Line(
        points={{-103,-30},{-88,-30},{-88,-21.36},{-65.52,-21.36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceCdot.flange,mBeva_Complete. InFlow_sf) annotation (Line(
        points={{-15.8,49.9},{-4,49.9},{-4,8.4},{-18,8.4}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(mBeva_Complete.OutFlow, pdropHP.InFlow) annotation (Line(
        points={{-18,-21.36},{0,-21.36},{0,-18},{23,-18}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(pdropHP.OutFlow, sinkP.flangeB) annotation (Line(
        points={{41,-18},{50,-18},{50,-26},{69.6,-26}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (
      Diagram(graphics),
      experiment(StopTime=50, Tolerance=1e-007),
      __Dymola_experimentSetupOutput);
  end Comparison1DHx;

  model Test_Evaporator
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot3_2(
      Mdot_0=3.148,
      cp=1907,
      rho=937.952,
      T_0=398.15)
      annotation (Placement(transformation(extent={{58,40},{38,60}})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DConst eva(
      Mdotnom_sf=3.148,
      Mdotnom_wf=0.3335,
      Mdotconst_wf=false,
      steadystate_h_wf=true,
      steadystate_T_wall=true,
      steadystate_T_sf=false,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      redeclare package Medium1 = ThermoCycle.Media.Solkatherm_CPSmooth,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.VaporQualityDependance,
      Unom_l=4000,
      Unom_tp=4000,
      Unom_v=4000,
      N=30,
      V_sf=0.02,
      V_wf=0.02,
      Unom_sf=15000,
      pstart_wf=888343,
      Tstart_inlet_wf=356.26,
      Tstart_outlet_wf=397.75,
      Tstart_inlet_sf=398.15,
      Tstart_outlet_sf=389.45)
      annotation (Placement(transformation(extent={{-28,2},{8,40}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      Mdot_0=0.3335,
      redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
      p=888343,
      T_0=356.26)
      annotation (Placement(transformation(extent={{-90,-2},{-70,18}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(
      redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
      h=255110,
      p0=888343)
      annotation (Placement(transformation(extent={{70,-4},{90,16}})));
  equation
    connect(eva.inletSf, source_Cdot3_2.flange) annotation (Line(
        points={{8,30.5},{16,30.5},{16,30},{24,30},{24,49.9},{39.8,49.9}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, eva.inletWf) annotation (Line(
        points={{-71,8},{-66,8},{-66,6},{-54,6},{-54,11.5},{-28,11.5}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(eva.outletWf, sinkP.flangeB) annotation (Line(
        points={{8,11.5},{36,11.5},{36,14},{64,14},{64,6},{71.6,6}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end Test_Evaporator;

  model Test_MBevaNew
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      UseT=false,
      h_0=852450,
      Mdot_0=0.05,
      redeclare package Medium = ThermoCycle.Media.Water,
      p=6000000)
      annotation (Placement(transformation(extent={{-84,-54},{-64,-34}})));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-100,-16},{-80,4}},
            rotation=0)));
    Modelica.Blocks.Sources.Constant Pout(k=1e5)
      annotation (Placement(transformation(extent={{110,0},{90,20}}, rotation=
             0)));
   ThermoCycle.Components.Units.HeatExchangers.MBeva MB_eva(
      A=0.0314159,
      L=1,
      M_tot=9.35E+01,
      c_wall=385,
      rho_wall=8.93e3,
      TwSB(start=510.97 + 50, displayUnit="K"),
      TwTP(start=548.79 + 21, displayUnit="K"),
      TwSH(start=585.97 + 35, displayUnit="K"),
      Tsf_SU_start=360 + 273.15,
      U_SB=3000,
      U_TP=10000,
      U_SH=3000,
      L_SB(start=0.2),
      L_TP(start=0.4),
      h_EX(start=3043000),
      Void=0.665,
      dVoid_dp=0,
      dVoid_dh=0,
      Usf=20000,
      ETA=1,
      redeclare package Medium = ThermoCycle.Media.Water,
      p(start=6000000),
      dTsf_start=343.15)
      annotation (Placement(transformation(extent={{-26,-38},{22,10}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
      rho=1000,
      Mdot_0=2,
      cp=2046,
      T_0=653.15) annotation (Placement(transformation(extent={{2,30},{22,50}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
        Medium =
          ThermoCycle.Media.Water)
      annotation (Placement(transformation(extent={{76,-34},{96,-14}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      UseNom=true,
      redeclare package Medium = ThermoCycle.Media.Water,
      Mdot_nom=0.05,
      p_nom=6000000,
      T_nom=643.15,
      DELTAp_nom=5000000)
      annotation (Placement(transformation(extent={{46,-40},{66,-20}})));
  equation
    connect(Hin.y, sourceMdot.in_h) annotation (Line(
        points={{-79,-6},{-68,-6},{-68,-38}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Pout.y, sinkP.in_p0) annotation (Line(
        points={{89,10},{82,10},{82,-15.2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sourceCdot.flange, MB_eva.InFlow_sf) annotation (Line(
        points={{20.2,39.9},{34,39.9},{34,0.4},{22,0.4}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, MB_eva.InFlow) annotation (Line(
        points={{-65,-44},{-58,-44},{-58,-40},{-50,-40},{-50,-29.36},{-25.52,
            -29.36}},
        color={0,0,255},
        smooth=Smooth.None));

    connect(MB_eva.OutFlow, valve.InFlow) annotation (Line(
        points={{22,-29.36},{40,-29.36},{40,-30},{47,-30}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(valve.OutFlow, sinkP.flangeB) annotation (Line(
        points={{65,-30},{72,-30},{72,-24},{77.6,-24}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,60}},
            preserveAspectRatio=true),
                        graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
              60}})),
      experiment(StopTime=1000),
      __Dymola_experimentSetupOutput);
  end Test_MBevaNew;

  model MBFlooded_NTU

  replaceable package Medium = ThermoCycle.Media.SES36_CP;
  replaceable package MediumINC =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66;

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot SourceWater(  redeclare
        package Medium =                                                              Medium,
      Mdot_0=0.3388,
      p=835000,
      T_0=333.15)
      annotation (Placement(transformation(extent={{-88,-34},{-68,-14}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP SinkWater(  redeclare
        package Medium =                                                              Medium,
      h=198807,
      p0=850000)
      annotation (Placement(transformation(extent={{78,-30},{98,-10}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot_pT sourceMdot_pT( redeclare
        package Medium =                                                              MediumINC,
      Mdot_0=2.97,
      p=200000,
      T_0=398.15)
      annotation (Placement(transformation(extent={{88,18},{68,38}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP_pT sinkP_pT( redeclare
        package Medium =                                                              MediumINC,
      p0=200000,
      T=387.15)
      annotation (Placement(transformation(extent={{-74,14},{-94,34}})));

    HeatExchangers.MovingBoundary.MovingBoundaryFlooded_NTU
      movingBoundaryFlooded_NTU( redeclare package Medium1 =                           Medium,
          redeclare package Medium2 =                                                  MediumINC,
      c_w=500,
      DVVdt=0,
      M_w=69,
      c_sf=2000,
      U_sc=3000,
      U_tp=8700,
      U_sf=1500,
      h_ex(start=198807),
      AA=0.00006571,
      LL=563,
      VV=0.1,
      p_wf(start=1000000),
      Tw_sc(start=353.15),
      Tw_tp(start=373.15),
      Tsf_su(start=398.15),
      Tsf_ex(start=387.15))
      annotation (Placement(transformation(extent={{-34,-14},{4,24}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      UseNom=true,
      redeclare package Medium = Medium,
      Mdot_nom=0.3388,
      p_nom=30000,
      T_nom=385.15,
      DELTAp_nom=50000)
      annotation (Placement(transformation(extent={{30,-26},{50,-6}})));
  equation
    connect(SourceWater.flangeB, movingBoundaryFlooded_NTU.InFlow_wf) annotation (
       Line(
        points={{-69,-24},{-64,-24},{-64,-26},{-56,-26},{-56,-6.02},{-33.62,
            -6.02}},
        color={0,0,255},
        smooth=Smooth.None));

    connect(sourceMdot_pT.flangeB, movingBoundaryFlooded_NTU.InFlow_sf)
      annotation (Line(
        points={{69,28},{40,28},{40,16},{26,16},{26,15.26},{3.24,15.26}},
        color={0,127,0},
        smooth=Smooth.None));
    connect(sinkP_pT.flangeB, movingBoundaryFlooded_NTU.OutFlow_sf) annotation (
        Line(
        points={{-75.6,24},{-62,24},{-62,16.4},{-33.62,16.4}},
        color={0,127,0},
        smooth=Smooth.None));
    connect(movingBoundaryFlooded_NTU.OutFlow_wf, valve.InFlow) annotation (Line(
        points={{3.24,-6.02},{14,-6.02},{14,-16},{31,-16}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(valve.OutFlow, SinkWater.flangeB) annotation (Line(
        points={{49,-16},{58,-16},{58,-20},{79.6,-20}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics),
      experiment(StopTime=300),
      __Dymola_experimentSetupOutput);
  end MBFlooded_NTU;

  model FiniteVolumeFlooded

  replaceable package Medium = ThermoCycle.Media.SES36_CP;
  replaceable package MediumINC =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66;

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot SourceWater(  redeclare
        package Medium =                                                              Medium,
      Mdot_0=0.3388,
      p=835000,
      T_0=333.15)
      annotation (Placement(transformation(extent={{-94,-22},{-74,-2}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot SourceINC( redeclare
        package Medium =                                                                        MediumINC,
      Mdot_0=2.97,
      p=200000,
      T_0=398.15)
      annotation (Placement(transformation(extent={{78,44},{58,64}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP SinkWater(  redeclare
        package Medium =                                                              Medium,
      h=245695,
      p0=835000)
      annotation (Placement(transformation(extent={{70,-10},{90,10}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkINC( redeclare
        package Medium =                                                                 MediumINC,
      h=153804,
      p0=200000)
      annotation (Placement(transformation(extent={{-72,42},{-92,62}})));

    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc hx1DInc( redeclare
        package Medium1 =                                                              Medium, redeclare
        package Medium2 =                                                                                                 MediumINC,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      N=20,
      Mdotnom_sf=30,
      V_sf=0.03781,
      V_wf=0.03781,
      A_sf=16.18,
      A_wf=16.18,
      Unom_sf=1500,
      Unom_l=3000,
      Unom_tp=8700,
      Unom_v=3000,
      M_wall=69,
      Mdotnom_wf=0.3388,
      pstart_sf=200000,
      pstart_wf=835000,
      Tstart_inlet_wf=333.15,
      Tstart_outlet_wf=383.15,
      Tstart_inlet_sf=398.15,
      Tstart_outlet_sf=387.15)
      annotation (Placement(transformation(extent={{-50,-4},{10,56}})));

    ThermoCycle.Components.FluidFlow.Sensors.SensTp sensTp( redeclare package
        Medium =                                                                      Medium)
      annotation (Placement(transformation(extent={{26,-2},{46,18}})));
  equation
    connect(SourceWater.flangeB, hx1DInc.inlet_fl1) annotation (Line(
        points={{-75,-12},{-60,-12},{-60,14},{-43.0769,14},{-43.0769,14.4615}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(SourceINC.flangeB, hx1DInc.inlet_fl2) annotation (Line(
        points={{59,54},{54,54},{54,58},{38,58},{38,39.8462},{2.61538,39.8462}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(hx1DInc.outlet_fl2, sinkINC.flangeB) annotation (Line(
        points={{-42.6154,39.3846},{-54,39.3846},{-54,52},{-73.6,52}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(hx1DInc.outlet_fl1, sensTp.InFlow) annotation (Line(
        points={{3.07692,14.4615},{10,14.4615},{10,4},{29,4},{29,3.2}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sensTp.OutFlow, SinkWater.flangeB) annotation (Line(
        points={{43,3.2},{48,3.2},{48,0},{71.6,0}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics),
      experiment(StopTime=300),
      __Dymola_experimentSetupOutput);
  end FiniteVolumeFlooded;



  model FluidProperties
  replaceable package MediumINC =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66;
  replaceable package Medium = ThermoCycle.Media.Water;

        parameter Modelica.SIunits.Temperature T_su = 250 +273.15;
        parameter Modelica.SIunits.Temperature T_ex = 215 +273.15;
        parameter Modelica.SIunits.AbsolutePressure Pinc = 2E5;

         Modelica.SIunits.SpecificHeatCapacity Cp_sf;
        MediumINC.ThermodynamicState Incompressible;
  Medium.SaturationProperties sat "TP: Two-phase thermpdynamic state";
  Medium.Temperature T_tp;
  parameter Modelica.SIunits.AbsolutePressure  p_wf = 1E5;

  Modelica.SIunits.SpecificEnthalpy h_l;
  Modelica.SIunits.SpecificEnthalpy h_v;
  equation
  Incompressible = MediumINC.setState_pT(Pinc,(T_su + T_ex)/2);

  Cp_sf = MediumINC.specificHeatCapacityCp(Incompressible);

    sat = Medium.setSat_p(p_wf);
    T_tp = Medium.saturationTemperature_sat(sat);
    h_l = Medium.bubbleEnthalpy(sat);
    h_v = Medium.dewEnthalpy(sat);
  end FluidProperties;

  model Test_p_drop
  replaceable package Medium = ThermoCycle.Media.SES36_CP;
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP SinkWater(  redeclare
        package Medium =                                                              Medium,
      h=198807,
      p0=850000)
      annotation (Placement(transformation(extent={{42,24},{62,44}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      UseNom=true,
      redeclare package Medium = Medium,
      Mdot_nom=0.3388,
      p_nom=835000,
      T_nom=385.15,
      DELTAp_nom=20000)
      annotation (Placement(transformation(extent={{-6,-14},{14,6}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot SourceWater(  redeclare
        package Medium =                                                              Medium,
      Mdot_0=0.3388,
      p=835000,
      T_0=333.15)
      annotation (Placement(transformation(extent={{-84,-12},{-64,8}})));
  equation
    connect(valve.OutFlow,SinkWater. flangeB) annotation (Line(
        points={{13,-4},{34,-4},{34,34},{43.6,34}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(SourceWater.flangeB, valve.InFlow) annotation (Line(
        points={{-65,-2},{-10,-2},{-10,-4},{-5,-4}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end Test_p_drop;

  model MBFlooded_LMTD

  replaceable package Medium = ThermoCycle.Media.SES36_CP;
  replaceable package MediumINC =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66;

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot SourceWater(  redeclare
        package Medium =                                                              Medium,
      Mdot_0=0.3388,
      p=835000,
      T_0=333.15)
      annotation (Placement(transformation(extent={{-88,-34},{-68,-14}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP SinkWater(  redeclare
        package Medium =                                                              Medium,
      h=198807,
      p0=850000)
      annotation (Placement(transformation(extent={{78,-30},{98,-10}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot_pT sourceMdot_pT( redeclare
        package Medium =                                                              MediumINC,
      Mdot_0=2.97,
      p=200000,
      T_0=398.15)
      annotation (Placement(transformation(extent={{88,18},{68,38}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP_pT sinkP_pT( redeclare
        package Medium =                                                              MediumINC,
      p0=200000,
      T=387.15)
      annotation (Placement(transformation(extent={{-74,14},{-94,34}})));

    HeatExchangers.MovingBoundary.MovingBoundaryFlooded
      movingBoundaryFlooded_LMTD( redeclare package Medium1 =                           Medium,
          redeclare package Medium2 =                                                  MediumINC,
      c_w=500,
      DVVdt=0,
      M_w=69,
      c_sf=2000,
      U_sc=3000,
      U_tp=8700,
      U_sf=1500,
      h_ex(start=198807),
      AA=0.00006571,
      LL=563,
      VV=0.1,
      l_sc(start=100),
      p_wf(start=1000000),
      Tw_sc(start=353.15),
      Tw_tp(start=373.15),
      Tsf_su(start=398.15),
      Tsf_ex(start=387.15))
      annotation (Placement(transformation(extent={{-36,-14},{2,24}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      UseNom=true,
      redeclare package Medium = Medium,
      Mdot_nom=0.3388,
      p_nom=30000,
      T_nom=385.15,
      DELTAp_nom=50000)
      annotation (Placement(transformation(extent={{30,-26},{50,-6}})));
  equation

    connect(valve.OutFlow, SinkWater.flangeB) annotation (Line(
        points={{49,-16},{58,-16},{58,-20},{79.6,-20}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(SourceWater.flangeB, movingBoundaryFlooded_LMTD.InFlow_wf)
      annotation (Line(
        points={{-69,-24},{-64,-24},{-64,-22},{-58,-22},{-58,-6.02},{-35.62,
            -6.02}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(movingBoundaryFlooded_LMTD.OutFlow_wf, valve.InFlow) annotation (
        Line(
        points={{1.24,-6.02},{12,-6.02},{12,-14},{31,-14},{31,-16}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sinkP_pT.flangeB, movingBoundaryFlooded_LMTD.OutFlow_sf)
      annotation (Line(
        points={{-75.6,24},{-50,24},{-50,16.4},{-35.62,16.4}},
        color={0,127,0},
        smooth=Smooth.None));
    connect(movingBoundaryFlooded_LMTD.InFlow_sf, sourceMdot_pT.flangeB)
      annotation (Line(
        points={{1.24,15.26},{34,15.26},{34,28},{69,28}},
        color={0,127,0},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics),
      experiment(StopTime=300),
      __Dymola_experimentSetupOutput);
  end MBFlooded_LMTD;

  model Test_MB_NTU

    HeatExchangers.MovingBoundary.MovingBoundary_NTU movingBoundary_NTU(
      redeclare package Medium1 = ThermoCycle.Media.Water,
      AA=0.0314159,
      LL=1,
      M_w=9.35E+01,
      c_w=385,
      U_sc=3000,
      U_tp=10000,
      U_sh=3000,
      U_sf=20000,
      l_sc(start=0.2),
      l_tp(start=0.4),
      h_ex(start=3043000),
      VV=0.665,
      p_wf(start=6000000),
      Tw_sc(start=560.35),
      Tw_tp(start=569.79),
      Tw_sh(start=620.97),
      Tsf_su(start=633.15),
      Tsf_ex(start=563.15))
      annotation (Placement(transformation(extent={{-36,-26},{40,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      UseT=false,
      h_0=852450,
      Mdot_0=0.05,
      redeclare package Medium = ThermoCycle.Media.Water,
      p=6000000)
      annotation (Placement(transformation(extent={{-74,-44},{-54,-24}})));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-90,-6},{-70,14}},
            rotation=0)));
    Modelica.Blocks.Sources.Constant Pout(k=1e5)
      annotation (Placement(transformation(extent={{120,10},{100,30}},
                                                                     rotation=
             0)));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
        Medium =
          ThermoCycle.Media.Water)
      annotation (Placement(transformation(extent={{86,-24},{106,-4}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      UseNom=true,
      redeclare package Medium = ThermoCycle.Media.Water,
      Mdot_nom=0.05,
      p_nom=6000000,
      T_nom=643.15,
      DELTAp_nom=5000000)
      annotation (Placement(transformation(extent={{56,-30},{76,-10}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
      rho=1000,
      Mdot_0=2,
      cp=2046,
      T_0=653.15) annotation (Placement(transformation(extent={{24,54},{44,74}})));
  equation
    connect(Hin.y,sourceMdot. in_h) annotation (Line(
        points={{-69,4},{-58,4},{-58,-28}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, movingBoundary_NTU.InFlow_wf) annotation (Line(
        points={{-55,-34},{-48,-34},{-48,-30},{-40,-30},{-40,-11.72},{-35.24,-11.72}},
        color={0,0,255},
        smooth=Smooth.None));

    connect(Pout.y,sinkP. in_p0) annotation (Line(
        points={{99,20},{92,20},{92,-5.2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(valve.OutFlow,sinkP. flangeB) annotation (Line(
        points={{75,-20},{82,-20},{82,-14},{87.6,-14}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(movingBoundary_NTU.OutFlow_wf, valve.InFlow) annotation (Line(
        points={{38.48,-11.72},{42,-11.72},{42,-20},{57,-20}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceCdot.flange, movingBoundary_NTU.InFlow_sf) annotation (Line(
        points={{42.2,63.9},{62,63.9},{62,26.36},{38.48,26.36}},
        color={255,0,0},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end Test_MB_NTU;

  model Test_OnePhase
  replaceable package Medium = ThermoCycle.Media.Water;
    HeatExchangers.MovingBoundary.Cell_OnePhase cell_OnePhase( redeclare
        package Medium =                                                                  Medium,
      Nt=1,
      AA=0.5,
      Mdotnom=1,
      Unom=100,
      pstart=1000000)
      annotation (Placement(transformation(extent={{-30,-36},{20,24}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot( redeclare
        package Medium =                                                                          Medium,
      Mdot_0=1,
      p=2000000,
      T_0=323.15)
      annotation (Placement(transformation(extent={{-92,-8},{-72,12}})));
    ThermoCycle.Components.HeatFlow.Sources.HeatSource_cell heatSource_cell
      annotation (Placement(transformation(extent={{-20,46},{0,66}})));
    Modelica.Blocks.Sources.Constant const(k=80000)
      annotation (Placement(transformation(extent={{-68,66},{-48,86}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
        Medium =                                                                                  Medium, p0
        =1000000)
      annotation (Placement(transformation(extent={{48,-12},{68,8}})));
  equation
    connect(heatSource_cell.thermalPort, cell_OnePhase.thermalPortL) annotation (
        Line(
        points={{-10.1,51.9},{-10.1,31.95},{-5,31.95},{-5,9}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, cell_OnePhase.InFlow) annotation (Line(
        points={{-73,2},{-54,2},{-54,-6},{-30,-6}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(const.y, heatSource_cell.Phi) annotation (Line(
        points={{-47,76},{-10,76},{-10,60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(cell_OnePhase.OutFlow, sinkP.flangeB) annotation (Line(
        points={{20,-5.7},{30,-5.7},{30,-2},{40,-2},{40,2},{49.6,2},{49.6,-2}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end Test_OnePhase;

  model Test_TwoPhase
  replaceable package Medium = ThermoCycle.Media.Water;
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot( redeclare
        package Medium =                                                                          Medium,
      Mdot_0=1,
      p=100000,
      T_0=373.15)
      annotation (Placement(transformation(extent={{-92,-8},{-72,12}})));
    ThermoCycle.Components.HeatFlow.Sources.HeatSource_cell heatSource_cell
      annotation (Placement(transformation(extent={{-20,46},{0,66}})));
    Modelica.Blocks.Sources.Constant const(k=1000)
      annotation (Placement(transformation(extent={{-68,66},{-48,86}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
        Medium =                                                                                  Medium, p0=
         100000)
      annotation (Placement(transformation(extent={{76,-12},{96,8}})));
    HeatExchangers.MovingBoundary.Cell_TwoPhase cell_TwoPhase(redeclare package
        Medium =                                                                                  Medium,
      AA=0.5,
      Mdotnom=1,
      Unom=100,
      hstart=417500,
      pstart=100000)
                annotation (Placement(transformation(extent={{-14,-18},{24,24}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(redeclare package
        Medium =                                                                                  Medium,
      UseNom=true,
      Mdot_nom=1,
      p_nom=100000,
      T_nom=373.15,
      DELTAp_nom=20000)
      annotation (Placement(transformation(extent={{32,-6},{52,14}})));
  equation
    connect(const.y, heatSource_cell.Phi) annotation (Line(
        points={{-47,76},{-10,76},{-10,60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, cell_TwoPhase.InFlow) annotation (Line(
        points={{-73,2},{-50,2},{-50,3},{-14,3}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(heatSource_cell.thermalPort, cell_TwoPhase.thermalPortL) annotation (
        Line(
        points={{-10.1,51.9},{-10.1,36},{-2,36},{-2,13.5},{5,13.5}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(cell_TwoPhase.OutFlow, valve.InFlow) annotation (Line(
        points={{24,3.21},{23,3.21},{23,4},{33,4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(valve.OutFlow, sinkP.flangeB) annotation (Line(
        points={{51,4},{64,4},{64,-2},{77.6,-2}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end Test_TwoPhase;
end Test;
