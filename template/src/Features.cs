using System.Linq;
using PX.Data;
using PX.Objects.PM;
using PX.Objects.CS;

namespace MyProject
{
    class Features
    {
        public static bool MyExtension
        {
            get
            {
                // return PXAccess.FeatureInstalled<PX.Objects.CS.FeaturesSet.retainage>();
		return true;
            }
        }
    }
}
