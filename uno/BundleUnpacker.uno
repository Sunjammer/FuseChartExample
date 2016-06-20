using Uno;
using Uno.IO;
using Uno.UX;
using Uno.Text;
using Uno.Threading;
using Fuse.Scripting;
using Uno.Compiler.ExportTargetInterop;
using BundleUnpacker.Utils;

namespace BundleUnpacker
{
	[UXGlobalModule]
	public class BundleUnpacker : NativeModule
	{
		static readonly BundleUnpacker _instance;
		public BundleUnpacker()
		{
			if(_instance != null) return;
			Resource.SetGlobalKey(_instance = this, "BundleUnpacker");
			AddMember(new NativePromise<string, Fuse.Scripting.Object>("unpack", Unpack, null));
		}
		
		static BundleFile GetFile(string name)
		{
			foreach(var file in Bundle.AllFiles)
				if(file.Name == name) return file;
			return null;
		}
		
		static Future<string> Unpack(object[] args)
		{
			var p = new Promise<string>();
			var fileName = args.ValueOrDefault<string>(0, "");
			var overwrite = args.ValueOrDefault<bool>(1,false);
			if(fileName!="")
			{
				BundleFile file = GetFile(fileName);
				if(file != null)
				{
					var path = GetTempDir() + "/" + fileName;
					if(overwrite || !File.Exists(path))
					{
						try
						{
							File.WriteAllBytes(path, file.ReadAllBytes());
						}
						catch(Exception e)
						{
							p.Reject(e);
							return p;
						}
					}
					p.Resolve("file://"+path);
				}
				else
				{
					p.Reject(new Exception("Invalid bundle file name"));
				}
			}
				
			return p;
		}
		
		[Foreign(Language.ObjC)]
		static extern(iOS) string GetTempDir()
		@{
			return NSTemporaryDirectory();
		@}
		
		[Foreign(Language.Java)]
		static extern(Android) string GetTempDir()
		@{
			return com.fuse.Activity.getRootActivity().getExternalCacheDir().getAbsolutePath();
		@}
		
		static extern(!Mobile) string GetTempDir()
		{
			var dir = Uno.IO.Directory.GetUserDirectory(Uno.IO.UserDirectory.Data) + "/Fuse_ExtractedBundles"; //Not exactly a killer approach, this
				if (!Directory.Exists(dir))
					Directory.CreateDirectory(dir);
			return dir;
		}
	}
}
