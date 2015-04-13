within MovingBoundaryLibrary.Components.Evaporator.Unit;
model EvaDw
replaceable package Medium =
     ExternalMedia.Examples.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
  ThermoCycle.Interfaces.Fluid.FlangeA InflowPF(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-106,
            -70},{-86,-50}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutflowPF(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{86,-70},
            {106,-50}})));
  SecondaryFluid.SecondaryFluid secondaryFluid(
    Usf=Unomsf,
    AA=AA,
    YY=YY,
    L_total=Ltotal,
    Tstart=Tstartsf,
    n=nCV,
    DTstart=DTstartsf,
    eps_NTU=epsNTU_sf)
    annotation (Placement(transformation(extent={{-30,60},{34,100}})));
  MovingBoundaryLibrary.Components.Wall.wall2volumes Wall(
    cp_w=cpw,
    L_total=Ltotal,
    M_w=Mw,
    TstartWall=TstartWall)
    annotation (Placement(transformation(extent={{-18,-24},{22,24}})));
  ThermoCycle.Interfaces.Fluid.Flange_Cdot InFlowSF
    annotation (Placement(transformation(extent={{86,48},
            {106,68}})));
            EvaDry evaDry(redeclare package Medium = Medium,
    AA=AA,
    YY=YY,
    Ltotal=Ltotal,
    Mdotnom=Mdotnom,
    UnomSH=UnomSH,
    UnomTP=UnomTP,
    pstart=pstart,
    hstartSH=hstartSH,
    lstartSH=lstartSH,
    hstartTP=hstartTP,
    lstartTP=lstartTP,
    eps_NTU=epsNTU_pf,
    VoidFraction=VoidFraction,
    VoidF=VoidF)
                annotation (Placement(
        transformation(extent={{-24,-98},{38,-60}})));

/* GEOMETRIES */
final parameter Integer  nCV= 2;
parameter Modelica.SIunits.Area AA = 0.0019 "Channel cross section";
parameter Modelica.SIunits.Length YY "Channel perimeter";
parameter Modelica.SIunits.Length Ltotal=500
    "Total length of the heat exchanger";

parameter Boolean VoidFraction = true
    "Set to true to calculate the void fraction to false to keep it constant";
parameter Real VoidF = 0.8 "Constantat void fraction" annotation (Dialog(enable= not VoidFraction));

    /* WALL */
parameter Modelica.SIunits.SpecificHeatCapacity cpw
    "Specific heat capacity (constant)"                                                       annotation(Dialog(group="Metal Wall",__Dymola_label="Cp wall:"));
    parameter Modelica.SIunits.Mass Mw "Total mass flow of the wall" annotation(Dialog(group="Metal Wall",__Dymola_label="Mass wall:"));

  /* BOOLEAN */
parameter Boolean epsNTU_sf = false "SF-wall :If True use eps-NTU " annotation (Dialog(group = "Heat transfer"));
parameter Boolean epsNTU_pf = false "PF-wall :If True use eps-NTU  " annotation (Dialog(group = "Heat transfer"));
parameter Boolean counterCurrent = true
    "If true countercurrent - PARALLEL FLOW NOT STABLE";

    /* HEAT TRANSFER */
parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate" annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomTP=9000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomSH=2500
    "SC - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unomsf=1000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));

    /* INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartTP=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartSH=1E5 "SC: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartTP=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSH=1 "SC:Start value of length"
    annotation (Dialog(tab="Initialization"));

/* initialization wall */
parameter Modelica.SIunits.Temperature TstartWall[nCV]
    "Start temperature of the wall"                                                        annotation (Dialog(tab="Initialization",group= "Wall"));
parameter Boolean SteadyStateWall = false
    "If true set Twall to zero during initialization"                                      annotation (Dialog(tab="Initialization",group= "Wall"));

       /* Steady state working fluid */
parameter Medium.SpecificEnthalpy h_pf_out = 1E5
    "Outlet enthalpy of the primary fluid"                                                 annotation(Dialog(tab="Initialization", enable= Set_h_pf_out, group= "Primary fluid"));
parameter Boolean SteadyStatePF = false
    "If true set length and h_out derivative of PF to zero"                                     annotation(Dialog(tab="Initialization",group= "Primary fluid"));
parameter Boolean Set_h_pf_out = false
    "If true set PF outlet enthalpy during initialization equal to h_pf_out"                annotation(Dialog(tab="Initialization",group= "Primary fluid"));

    /* initialization secondary fluid */
parameter Modelica.SIunits.Temperature Tstartsf
    "Start value for average temperature of inlet cell" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));
parameter Modelica.SIunits.Temperature DTstartsf
    "Delta T to initialize second and third volume average temperature" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));

equation
    /* If statement to allow parallel or counter current structure*/
if counterCurrent then
connect( Wall.QmbOut, secondaryFluid.mbIn[nCV:-1:1]);
else
  connect(Wall.QmbOut, secondaryFluid.mbIn);
end if;
  connect(secondaryFluid.InFlow_sf, InFlowSF) annotation (Line(
      points={{30.8,80},{58,80},{58,58},{96,58}},
      color={255,0,0},
      smooth=Smooth.None));

initial equation
  if SteadyStateWall then
    der(Wall.Tw) = {0,0};
  end if;
if SteadyStatePF then
    der(evaDry.volumeTP.ll) = 0;
    der(evaDry.volumeSH.h_b) = 0;
  end if;
  if Set_h_pf_out then
    evaDry.volumeSH.h_b = h_pf_out;
  end if;

equation
  connect(Wall.QmbIn, evaDry.mbOut) annotation (
      Line(
      points={{0.4,-21.6},{0.4,-36},{7,-36},{7,-61.9}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(InflowPF, evaDry.InFlow) annotation (Line(
      points={{-96,-60},{-60,-60},{-60,-82},{-24.62,-82},{-24.62,-78.62}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(evaDry.OutFlow, OutflowPF) annotation (Line(
      points={{37.38,-78.62},{62,-78.62},{62,-60},{96,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                        graphics));
end EvaDw;
