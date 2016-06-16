using Fuse.Scripting;

namespace BundleUnpacker.Utils
{
  public static class JSObjectUtils
  {
    //Utility for fetching a value from an object array or a default value if it doesnt exist
  	public static T ValueOrDefault<T>(this object[] args, int index, T defaultValue)
  	{
  		if(index < 0 || index > args.Length-1) return defaultValue;
  		return Marshal.ToType<T>(args[index]);
  	}
  }
}
