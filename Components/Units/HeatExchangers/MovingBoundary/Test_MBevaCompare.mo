within Components.Units.HeatExchangers.MovingBoundary;
model Test_MBevaCompare

  replaceable package WorkingFluid = Components.Media.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium;

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    UseT=false,
    h_0=852450,
    Mdot_0=0.05,
    redeclare package Medium = WorkingFluid,
    p=6000000)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Constant Hin(k=852540)
    annotation (Placement(transformation(extent={{-120,0},{-100,20}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant Pout(k=1e5)
    annotation (Placement(transformation(extent={{40,-10},{60,10}},rotation=
           0)));
 MBeva_Complete_NTU                                MB_eva(
    A=0.0314159,
    L=1,
    M_tot=9.35E+01,
    c_wall=385,
    rho_wall=8.93e3,
    TwSB(start=510.97 + 50, displayUnit="K"),
    TwTP(start=548.79 + 21, displayUnit="K"),
    TwSH(start=585.97 + 35, displayUnit="K"),
    Tsf_SU_start=360 + 273.15,
    L_SB(start=0.2),
    L_TP(start=0.4),
    h_EX(start=3043000),
    Void=0.665,
    dVoid_dp=0,
    dVoid_dh=0,
    ETA=1,
    redeclare package Medium = WorkingFluid,
    p(start=6000000),
    dTsf_start=343.15,
    U_SB=5000,
    U_TP=10000,
    U_SH=5000,
    Usf=2000)
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    rho=1000,
    Mdot_0=2,
    cp=2046,
    T_0=653.15) annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =
        WorkingFluid)
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(
    UseNom=true,
    redeclare package Medium = WorkingFluid,
    Mdot_nom=0.05,
    p_nom=6000000,
    T_nom=643.15,
    DELTAp_nom=5000000)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
    Mdot_0=sourceMdot.Mdot_0,
    p=sourceMdot.p,
    h_0=sourceMdot.h_0,
    UseT=sourceMdot.UseT,
    T_0=sourceMdot.T_0,
    redeclare package Medium = WorkingFluid)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(
                                                          redeclare package
      Medium =
        WorkingFluid,
    p0=sinkP.p0,
    h=sinkP.h)
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1DConst hx1DConst(
    redeclare package Medium1 = WorkingFluid,
    M_wall=MB_eva.M_tot,
    c_wall=MB_eva.c_wall,
    Unom_l=MB_eva.U_SB,
    Unom_tp=MB_eva.U_TP,
    Unom_v=MB_eva.U_SH,
    Unom_sf=MB_eva.Usf,
    V_sf=MB_eva.A*MB_eva.L,
    V_wf=MB_eva.A*MB_eva.L,
    N=15,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
    Mdotnom_sf=sourceCdot1.Mdot_0,
    Mdotnom_wf=sourceMdot1.Mdot_0,
    A_sf=Modelica.Constants.pi*MB_eva.D*MB_eva.L,
    A_wf=Modelica.Constants.pi*MB_eva.D*MB_eva.L)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot1(
    Mdot_0=sourceCdot.Mdot_0,
    T_0=sourceCdot.T_0,
    T_ref=sourceCdot.T_ref,
    cp=sourceCdot.cp,
    rho=sourceCdot.rho)
                annotation (Placement(transformation(extent={{60,40},{40,60}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve1(
    redeclare package Medium = WorkingFluid,
    UseNom=valve.UseNom,
    Afull=valve.Afull,
    Xopen=valve.Xopen,
    DELTAp_0=valve.DELTAp_0,
    Mdot_nom=valve.Mdot_nom,
    p_nom=valve.p_nom,
    T_nom=valve.T_nom,
    DELTAp_nom=valve.DELTAp_nom,
    use_rho_nom=valve.use_rho_nom)
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=0.01,
    offset=852540,
    startTime=10,
    amplitude=0)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=100,
    offset=2,
    startTime=500,
    height=-1.7)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(Pout.y, sinkP.in_p0) annotation (Line(
      points={{61,6.66134e-16},{86,6.66134e-16},{86,-41.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceCdot.flange, MB_eva.InFlow_sf) annotation (Line(
      points={{41.8,-30.1},{30,-30.1},{30,-30},{20,-30},{20,-32},{10,-32}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, MB_eva.InFlow) annotation (Line(
      points={{-61,-50},{-20,-50},{-20,-44.4},{-9.8,-44.4}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(MB_eva.OutFlow, valve.InFlow) annotation (Line(
      points={{10,-44.4},{20,-44.4},{20,-50},{41,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(valve.OutFlow, sinkP.flangeB) annotation (Line(
      points={{59,-50},{81.6,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Pout.y, sinkP1.in_p0) annotation (Line(
      points={{61,4.44089e-16},{86,4.44089e-16},{86,38.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve1.OutFlow, sinkP1.flangeB) annotation (Line(
      points={{59,30},{81.6,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hx1DConst.outletWf, valve1.InFlow) annotation (Line(
      points={{10,35},{20,35},{20,30},{41,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot1.flange, hx1DConst.inletSf) annotation (Line(
      points={{41.8,49.9},{20,49.9},{20,45},{10,45}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, hx1DConst.inletWf) annotation (Line(
      points={{-61,30},{-20,30},{-20,35},{-10,35}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sine.y, sourceMdot1.in_h) annotation (Line(
      points={{-79,-10},{-64,-10},{-64,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, sourceMdot.in_h) annotation (Line(
      points={{-79,-10},{-64,-10},{-64,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, sourceCdot.M_dot_source) annotation (Line(
      points={{21,0},{30,0},{30,-20},{68,-20},{68,-28.2},{57,-28.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, sourceCdot1.M_dot_source) annotation (Line(
      points={{21,0},{30,0},{30,20},{70,20},{70,51.8},{57,51.8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_MBevaCompare;
