within Components.Units.Test.Water.Variations;
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
  ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package Medium
      =        Modelica.Media.Water.StandardWater)
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
