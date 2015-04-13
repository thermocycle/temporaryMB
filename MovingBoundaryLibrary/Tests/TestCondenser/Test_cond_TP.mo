within MovingBoundaryLibrary.Tests.TestCondenser;
model Test_cond_TP
  replaceable package Medium =ExternalMedia.Examples.WaterCoolProp;
  parameter Modelica.SIunits.AbsolutePressure pp= 3e6;
  parameter Medium.SaturationProperties sat =  Medium.setSat_p(pp) "Saturation";
  parameter Medium.SpecificEnthalpy h0 = Medium.dewEnthalpy(sat) - 100;
  MovingBoundaryLibrary.Components.Cells.TwoPhase twoPhaseTotal(
    redeclare package Medium = Medium,
    Type=false,
    AA=0.0019,
    YY=1.57,
    Ltotal=500,
    Mdotnom=0.5,
    Unom=8000,
    lstart=500,
    hstart=h0 - 200,
    pstart=3000000)
    annotation (Placement(transformation(extent={{-22,-58},{16,-2}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.5,
    UseT=false,
    h_0=h0,
    p=3000000,
    T_0=350.15)
    annotation (Placement(transformation(extent={{-94,-40},{-74,-20}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                       Medium, p0=
       3000000)
    annotation (Placement(transformation(extent={{38,-22},{58,-2}})));
  Components.SecondaryFluid.SecondaryFluid secondaryFluid(
    n=1,
    Usf=1000,
    AA=0.0019,
    YY=1.57,
    L_total=500,
    eps_NTU=true,
    Tstart=513.15,
    DTstart=283.15)
    annotation (Placement(transformation(extent={{-16,34},{12,62}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(Mdot_0=5, T_0=
        473.15)
    annotation (Placement(transformation(extent={{10,72},{30,92}})));
initial equation
        twoPhaseTotal.h_b = Medium.bubbleEnthalpy(sat);
equation

  connect(twoPhaseTotal.outFlow, sinkP.flangeB) annotation (Line(
      points={{16,-29.72},{32,-29.72},{32,-12},{39.6,-12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(secondaryFluid.mbIn[1], twoPhaseTotal.mbOut) annotation (Line(
      points={{-2,35.12},{-2,24},{-3,24},{-3,-4.8}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sourceCdot.flange, secondaryFluid.InFlow_sf) annotation (Line(
      points={{28.2,81.9},{42,81.9},{42,48},{10.6,48}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, twoPhaseTotal.inFlow) annotation (Line(
      points={{-75,-30},{-22,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_cond_TP;
