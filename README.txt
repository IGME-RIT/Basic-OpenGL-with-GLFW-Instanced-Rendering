Documentation Author: Niko Procopi 2019

This tutorial was designed for Visual Studio 2017 / 2019
If the solution does not compile, retarget the solution
to a different version of the Windows SDK. If you do not
have any version of the Windows SDK, it can be installed
from the Visual Studio Installer Tool

Welcome to the Instanced Rendering Tutorial!
Prerequesites: Object Loading

Instanced Rendering allows someone to draw an object
multiple times, with only one draw call. In our vertex
shader, rather than having the projecection, view, and
world matrices, we will have the projection matrix, the 
view matrix, and an array of world matrices.

Each instance of the geometry we are drawing will use
its own world matrix, allowing each one to have its
own position, rotation, and scale.

First we make our Transforms
    std::vector<Transform3D> transforms;
    for (int i = 0; i < 1000; i++)
    {
        Transform3D transform;
        transform.SetPosition(glm::vec3(i % 10, (i / 10) % 10, (i / 100 % 10)));
        transform.RotateX(1.5);
        transforms.push_back(transform);
    }

Next, we convert each one into a matrix
        std::vector<glm::mat4> matrices;

        // rotate cube transform and get a matrix for it
        for (int i = 0; i < transforms.size(); i++)
        {
            transforms[i].RotateY(dt);
            matrices.push_back(transforms[i].GetMatrix());
        }
		
We continually rotate each one, just for a nice effect.
We draw the instances with this function that we wrote:
	model->DrawInstanced(matrices);
	
Let's break that function down to understand how it works:

First we pass the array of matrices:
    glBindBuffer(GL_ARRAY_BUFFER, m_instanceBuffer);
    glBufferData(GL_ARRAY_BUFFER, matrices.size() * sizeof(glm::mat4), matrices.data(), GL_STATIC_DRAW);
	
Next, can skip the explanation for VertexAttributes, we've already
seen those in previous tutorails. To use instanced rendering, we
use a new function that we have not used before:
	glDrawElementsInstanced(GL_TRIANGLES, m_indices.size(), GL_UNSIGNED_INT, (void*)0, matrices.size());
	
This tells us that we want to draw triangles, the amount of indices in our index buffer is
m_indices.size(), GL_UNSIGNED_INT indicates that we are using a 32-bit (4-byte) index buffer,
matrices.size() is the number of times the model should be drawn

In our vertex shader, we have the world matrix, in the same layout that was set
on the C++ side: 
	in mat4 in_worldMat;
We only indicate one, and OpenGL automatically figures out which one should be used.

Congratulations, you're done with instanced rendering
