#!/bin/bash

# Set matplotlib settings according to $DISPLAY
MATPLOTLIBRC=$(${python_env}/bin/python -c "import matplotlib; print(matplotlib.matplotlib_fname())")

if [ -z "${DISPLAY}" ]; then
  cp /matplotlibrc_agg ${MATPLOTLIBRC}
else
  cp /matplotlibrc_tkagg ${MATPLOTLIBRC}
fi

if [ ! -z "$1" ]; then
  exec $@
fi

