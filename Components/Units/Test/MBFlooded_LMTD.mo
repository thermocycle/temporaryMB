within Components.Units.Test;
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
