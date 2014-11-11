within Components.Units.Test;
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
