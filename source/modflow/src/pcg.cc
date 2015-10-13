#ifndef INCLUDED_PCG
#include "pcg.h"
#define INCLUDED_PCG
#endif


// Library headers.

// PCRaster library headers.

// Module headers.

/**
* Destructor
*/
PCG::~PCG(){
}

/**
* Constructor
*/
PCG::PCG() :
  d_mxiter(0),
  d_iteri(0),
  d_npcond(0),
  d_hclose(-1.0),
  d_rclose(-1.0),
  d_relax(-1.0),
  d_nbpol(-1.0),
  d_iprpcg(1),
  d_mutpcg(3),  // append to pcrmf.lst only if convergence fails
  d_damp(-1.0),
  d_updated(true){
}


void PCG::setPCG(size_t mxiter, size_t iteri, size_t npcond, double hclose, double rclose, double relax, double nbpol, double damp, bool updated){
  d_mxiter = mxiter;
  d_iteri = iteri;
  d_npcond = npcond;
  d_hclose = hclose;
  d_rclose = rclose;
  d_relax = relax;
  d_nbpol = nbpol;
  d_damp = damp;
  d_updated = updated;
}


bool PCG::modified() const {
  return d_updated;
}


void PCG::update() {
  d_updated = false;
}


std::ostream& operator<<(std::ostream& os, const PCG& pcg){
  os << "# Generated by PCRaster Modflow" << std::endl;
  os << pcg.d_mxiter << " " << pcg.d_iteri << " " << pcg.d_npcond << std::endl;
  os << pcg.d_hclose << " " << pcg.d_rclose << " " << pcg.d_relax << " " << pcg.d_nbpol << " " << pcg.d_iprpcg << " " << pcg.d_mutpcg << " " << pcg.d_damp << std::endl;
  return os;
}
