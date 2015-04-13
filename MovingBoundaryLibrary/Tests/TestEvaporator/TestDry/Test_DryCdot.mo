within MovingBoundaryLibrary.Tests.TestEvaporator.TestDry;
model Test_DryCdot
  replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp;
  Components.Evaporator.EvaDry evaDry(
    redeclare package Medium = Medium,
    YY=1.57,
    hstartSH=3E6,
    hstartTP=2E6,
    lstartSH=450,
    lstartTP=50,
    pstart=6000000) annotation (Placement(transformation(extent={{-22,-82},{32,
            -42}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot
    sourceMdot(redeclare package Medium = Medium,Mdot_0=0.5,
    T_0=548.735)
               annotation (Placement(
        transformation(extent={{-96,-88},{-76,-68}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP
    sinkP(redeclare package Medium = Medium,
    p0=6000000,
    h=3.E6)
          annotation (Placement(transformation(
          extent={{76,-86},{96,-66}})));
  Components.SecondaryFluid.SecondaryFluid secondaryFluidCdot(
    Usf=1000,
    AA=0.0019,
    YY=1.57,
    L_total=500,
    n=n,
    Tstart=1473.15,
    DTstart=323.15) annotation (Placement(transformation(extent={{-20,36},{20,64}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot
    sourceCdot(
    cp=1000,
    Mdot_0=55,
    T_0=1273.15)
               annotation (Placement(
        transformation(extent={{38,70},{58,90}})));

      parameter Integer n=2;
parameter Boolean counterCurrent = true;
equation

  /* If statement to allow parallel or counter current structure*/
if counterCurrent then
connect( evaDry.mbOut, secondaryFluidCdot.mbIn[n:-1:1]);
else
  connect(evaDry.mbOut, secondaryFluidCdot.mbIn);
end if;
  connect(sourceCdot.flange, secondaryFluidCdot.InFlow_sf)
    annotation (Line(
      points={{56.2,79.9},{66,79.9},{66,
          50},{18,50}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(sourceMdot.flangeB, evaDry.InFlow) annotation (Line(
      points={{-77,-78},{-48,-78},{-48,-61.6},{-22.54,-61.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaDry.OutFlow, sinkP.flangeB) annotation (Line(
      points={{31.46,-61.6},{52,-61.6},{52,-76},{77.6,-76}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics));
end Test_DryCdot;
