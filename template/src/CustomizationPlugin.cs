using System;
using PX.Data;

namespace MyProject
{
    public class PECustomizationPlugin : Customization.CustomizationPlugin
    {
        public override void UpdateDatabase()
        {
            PXGraph.CreateInstance<PECustomizationGraph>().EnsureData(this);
        }
    }

    public static class GraphExt
    {
        public static void SaveChanges(this PXGraph graph)
        {
            graph.Actions.PressSave();
        }
    }
}
