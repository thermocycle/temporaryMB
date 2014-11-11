within Components.Units.Test;
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
