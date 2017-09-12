using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenGrab : MonoBehaviour {

    #region Variables
    public Shader curShader;
    public int iterations = 1;
    public float blurSpeed = 0.6f;
    public int downsample = 2;
    private Material curMaterial;
    #endregion

    #region Properties
    Material material
    {
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMaterial;
        }
    }
    #endregion

    void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!curShader && !curShader.isSupported)
        {
            enabled = false;
        }
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (curShader != null)
        {
            material.SetFloat("_BlurSize", 1.0f + 1 * blurSpeed);

            Graphics.Blit(sourceTexture, destTexture, material); //把图像传给Material，以便在Shader中处理
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    void Update()
    {

    }

    void OnDisable()
    {
        if (curMaterial)
        {
            DestroyImmediate(curMaterial);
        }
    }
}
