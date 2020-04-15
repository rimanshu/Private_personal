import setuptools
from distutils.extension import Extension
from Cython.Build import cythonize
import os


print("$$$$$$$$")
print(os.getcwd())
print("$$$$$$$$")
# with open("readme.txt", "r") as fh:
#    long_description = fh.read()

setuptools.setup(
    name='Genpact_ML',
    version='1.0.0',
    author="F&A Analytics ML Team",
    author_email="MLHelp@genpactonline.onmicrosoft.com",
    description="Testing Entity Extraction Service in TCA",
    long_description="Testing Entity Extraction Service in TCA",
    long_description_content_type="text/markdown",
    url="https://www.genpact.com",

    license='Genpact Proprietary',
    python_requires='>=3.6.8',
    classifiers=[
        "Development Status :: 1 - Beta",
        "Programming Language :: Python :: 3",
        "License :: Genpact Proprietary",
        "Operating System :: OS Independent",
    ],
    ext_modules=cythonize([Extension("entity_extractor.src.*", ["src/*.py"]),
                           Extension("entity_extractor.src.request_handlers.*", ["src/request_handlers/*.py"]),
                           Extension("entity_extractor.src.swagger_models.*", ["src/swagger_models/*.py"]),
                           Extension("entity_extractor.src.utils.*", ["src/utils/*.py"])
                           ], compiler_directives={'language_level': 3})
)
