/*
Title: Specular Maps
File Name: fragment.glsl
Copyright ? 2016
Author: David Erbelding
Written under the supervision of David I. Schwartz, Ph.D., and
supported by a professional development seed grant from the B. Thomas
Golisano College of Computing & Information Sciences
(https://www.rit.edu/gccis) at the Rochester Institute of Technology.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#version 400 core

in vec3 position;
in vec2 uv;
in mat3 tbn;

uniform sampler2D normalMap;
uniform samplerCube cubeMap;

// Camera position is required for reflection the same way it's used for specular shading
uniform vec3 cameraPosition;

void main(void)
{
	// calculate normal from normal map
	vec3 texnorm = normalize(vec3(texture(normalMap, uv)) * 2.0 - 1.0);
	vec3 norm = tbn * texnorm;

	// This part should mostly make sense.
	// We get a vector from the surface to the camera position.
	vec3 surfaceToEye = cameraPosition - position;
	// Reflect that vector over the surface normal, giving us the direction light would be reflecting to our eye from
	vec3 outVec = reflect(surfaceToEye, norm);
	
	// We use that direction vector to read from the cube map (like a backwards skybox)
	gl_FragColor = texture(cubeMap, outVec);
}