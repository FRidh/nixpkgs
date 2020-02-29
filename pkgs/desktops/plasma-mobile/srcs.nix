{ fetchgit }:

{
  plasma-camera = {
    version = "dev";
    src = fetchgit {
      url = "https://invent.kde.org/kde/plasma-camera.git";
      rev = "fdfa270524f43f9720cc3f3bf755412754733b46";
      sha256 = "sha256:1ng6r9hdqnvxg9x159bccix3x757a3bh11khcvcf672h0rxm0kbv";
    };  
  };
  plasma-phone-components = {
    version = "dev";
    src = fetchgit {
      url = "https://invent.kde.org/kde/plasma-phone-components.git";
      rev = "ca8f308727486e5d9781a1e4a4577465210599f8";
      sha256 = "sha256:048f06kzld3fc401x8z9jl4zkra59hnghrqnvxaqzhff40d15r6q";
    };
  };
  plasma-settings =  {
    version = "dev";
    src = fetchgit {
      url = "https://invent.kde.org/kde/plasma-settings.git";
      rev = "e1ecc4058d069919c8f1b42ae1d160932e15aa3f";
      sha256 = "sha256:0xnk8k92q6j92c2akgj68chhvcygxvsmzj7ypi5gm6vjzl6qwbrn";
    };
  };
  simplelogin = {
    version = "dev";
    src = fetchgit {
      url = "https://invent.kde.org/bshah/simplelogin.git";
      rev = "ffa841ec9766e4428f2f960b966bcc5b4e7e4982";
      sha256 = "sha256:18s9jhpsr9divf4inkghzi75dbgharzgq1m6r0ixcbm5a2mz91x0";
    };  
  };
  
}
