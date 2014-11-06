within Components;
package Media
  package WaterCoolProp "MB - CoolProp model of water"
    extends ExternalMedia.Media.CoolPropMedium(
      mediumName = "Water",
      substanceNames = {"water|enable_TTSE=1|calc_transport=1"},
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
      AbsolutePressure(start=10e5),
      SpecificEnthalpy(start=2e5));
  end WaterCoolProp;
end Media;
