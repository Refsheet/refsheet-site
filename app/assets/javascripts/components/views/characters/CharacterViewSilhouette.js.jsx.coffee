@CharacterViewSilhouette = ->
  `<Main title='Character' className='silhouette' style={{ display: 'none' }} fadeEffect>
      <section className='page-header'>
          <div className='page-header-backdrop silhouette-backdrop' />

          <div className='page-header-content'>
              <div className='container'>
                  <div className='character-card'>
                      <div className='character-details'>
                          <h1 className='name silhouette-text' />
                          <div className='silhouette-stagger'>
                              <div className='silhouette-text margin-top--large' />
                              <div className='silhouette-text margin-top--medium' />
                              <div className='silhouette-text margin-top--medium' />
                              <div className='silhouette-text margin-top--medium' />
                          </div>

                          <h2 className='silhouette-text margin-top--large' />
                          <div className='silhouette-stagger'>
                              <div className='silhouette-text' />
                          </div>
                      </div>

                      <div className='character-image silhouette-image'>
                          <div className='slant' />
                      </div>
                  </div>

                  <div className='card-panel' />
              </div>
          </div>
      </section>

      <section>
          <div className='container'>
              <div className='card-panel'>
                  <h1 className='silhouette-text' />
                  <div className='silhouette-stagger'>
                      <div className='silhouette-text margin-top--large' />
                      <div className='silhouette-text margin-top--medium' />
                      <div className='silhouette-text margin-top--medium' />
                      <div className='silhouette-text margin-top--medium' />
                  </div>
              </div>
          </div>
      </section>
  </Main>`
