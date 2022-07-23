# 7T-feedforward-feedback
The data and code for reproducing the main findings of "Cortical depth profiles of auditory and visual 7T functional MRI responses in human superior temporal areas" (2022)

# Cortical depth profiles of auditory and visual 7T functional MRI responses in human superior temporal areas

Lankinen, K.<sup>1, 2</sup>, Ahlfors, S.P.<sup>1, 2</sup>, Mamashli, F.<sup>1, 2</sup>, Blazejewska, A.I.<sup>1, 2</sup>, Raij, T.<sup>1, 2</sup>, Turpin, T.<sup>1</sup>, Polimeni, J.R.<sup>1, 2, 3</sup>, Ahveninen, J.<sup>1, 2</sup>   
   
<sup><sup>1</sup> Athinoula A. Martinos Center for Biomedical Imaging, Department of Radiology, Massachusetts General Hospital, Charlestown, MA 02129, USA                                               
<sup>2</sup> Department of Radiology, Harvard Medical School, Boston, MA 02115, USA                                                                                         
<sup>3</sup> Division of Health Sciences and Technology, Massachusetts Institute of Technology, Cambridge, MA 02139, USA </sup>  

***

Abstract:
*Invasive neurophysiological studies in non-human primates have shown different laminar activation profiles to auditory vs. visual stimuli in auditory cortices and adjacent polymodal areas. Means to examine the underlying feedforward vs. feedback type influences non-invasively have been limited in humans. Here, using 1-mm isotropic resolution 3D echo-planar imaging at 7T, we studied the intracortical depth profiles of functional magnetic resonance imaging (fMRI) blood oxygenation level dependent (BOLD) signals to brief auditory (noise bursts) and visual (checkerboard) stimuli. BOLD percent-signal-changes were estimated at 11 equally spaced intracortical depths, within regions-of-interest encompassing auditory (Heschl's gyrus, Heschl's sulcus, planum temporale, posterior superior temporal gyrus) and polymodal (middle and posterior superior temporal sulcus) areas. Effects of differing BOLD signal strengths for auditory and visual stimuli were controlled via normalization and statistical modeling. The BOLD depth profile shapes, modeled with quadratic regression, were significantly different for auditory vs. visual stimuli in auditory cortices, but not in polymodal areas. The different depth profiles could reflect sensory-specific feedforward vs. cross-sensory feedback influences, previously shown in laminar recordings in non-human primates. The results suggest that intracortical BOLD profiles can help distinguish between feedforward and feedback type influences in the human brain. Further experimental studies are still needed to clarify how underlying signal strength influences BOLD depth profiles under different stimulus conditions.*  
  

***
## Code
This repository contains one .m file which reproduces the main results in the manuscript, using the data provided in the ‘Depth_Data’ directory.
 *	**LME_model.m**
    *	This script calculates the LME model (formula 2 in the manuscript) and produces the data in Supplementary Tables S1 and S2. 
    *   The model also plot predicts values from the LME model.     

***
## Data
The ‘Data’ directory contains 7T fMRI depth profiles collected from 13 human participants who were presented with auditory and visual stimuli. The data contains average of the BOLD %-signal-change on each ROI for each subject. 
*	<span>**depth_profiles.mat**</span> with dimensions surfaces x subjects x conditions x ROIs x hemispheres

***

Further information, code, and data may be available upon request. 
Please refer to the manuscript or contact klankinen@mgh.harvard.edu. 
