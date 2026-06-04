import React from 'react';
import Link from '@docusaurus/Link';
import Layout from '@theme/Layout';
import Translate, {translate} from '@docusaurus/Translate';
import Ring from '@site/static/img/careit/care-it-ring.svg';
import Scope from '@site/static/img/careit/careit-scope.svg';
import styles from './index.module.css';

export default function Home(): JSX.Element {
  return (
    <Layout
      title={translate({
        id: 'homepage.meta.title',
        message: 'CARE-IT',
      })}
      description={translate({
        id: 'homepage.meta.description',
        message: 'Governance framework for digital clinical infrastructure',
      })}>
      <main>
        <div className={styles.page}>
          <section className={styles.hero}>
            <div className={styles.heroGrid}>
              <div className={styles.heroText}>
                <p className={styles.kicker}>
                  <Translate id="homepage.hero.kicker">CARE-IT Framework</Translate>
                </p>

                <h1 className={styles.heroTitle}>
                  <Translate id="homepage.hero.title">
                    Governance for Digital Clinical Infrastructure
                  </Translate>
                </h1>

                <p className={styles.lead}>
                  <Translate id="homepage.hero.lead">
                    CARE-IT is a reference framework for governing clinically relevant digital infrastructure in healthcare organizations.
                  </Translate>
                </p>

                <p className={styles.sublead}>
                  <Translate id="homepage.hero.sublead">
                    It focuses on clinical system constellations rather than isolated products or applications, aligning architecture, responsibility, risk, lifecycle, and innovation with clinical value.
                  </Translate>
                </p>

                <div className={styles.actions}>
                  <Link
                    className="button button--primary button--lg"
                    to="/framework/">
                    <Translate id="homepage.hero.cta.primary">
                      Explore the Framework
                    </Translate>
                  </Link>

                  <Link
                    className="button button--outline button--lg"
                    to="/framework/architecture/overview">
                    <Translate id="homepage.hero.cta.secondary">
                      View Architecture
                    </Translate>
                  </Link>
                </div>
              </div>

              <div className={styles.heroVisual}>
                <Ring className={styles.ring} />
              </div>
            </div>
          </section>

          <section className={styles.section}>
            <div className={styles.sectionHeader}>
              <p className={styles.kicker}>
                <Translate id="homepage.scope.kicker">Scope</Translate>
              </p>
              <h2>
                <Translate id="homepage.scope.title">
                  What CARE-IT applies to
                </Translate>
              </h2>
            </div>

            <div className={styles.scopeBlock}>
              <Scope
                className={styles.scopeImage}
                aria-label={translate({
                  id: 'homepage.scope.imageAlt',
                  message: 'CARE-IT scope diagram',
                })}
                role="img"
              />
              <p className={styles.sectionText}>
                <Translate id="homepage.scope.text">
                  CARE-IT applies to digital clinical infrastructure and addresses clinical system constellations composed of applications, devices, data, and integration.
                </Translate>
              </p>
            </div>
          </section>

          <section className={styles.section}>
            <div className={styles.sectionHeader}>
              <p className={styles.kicker}>
                <Translate id="homepage.logic.kicker">Framework Logic</Translate>
              </p>
              <h2>
                <Translate id="homepage.logic.title">
                  How CARE-IT works
                </Translate>
              </h2>
            </div>

            <div className={styles.cards}>
              <div className={styles.card}>
                <h3>
                  <Translate id="homepage.logic.card1.title">Principles</Translate>
                </h3>
                <p>
                  <Translate id="homepage.logic.card1.text">
                    Normative orientation for how digital clinical infrastructure should be governed.
                  </Translate>
                </p>
              </div>

              <div className={styles.card}>
                <h3>
                  <Translate id="homepage.logic.card2.title">Domains</Translate>
                </h3>
                <p>
                  <Translate id="homepage.logic.card2.text">
                    Governance domains that structure how clinical system constellations are managed.
                  </Translate>
                </p>
              </div>

              <div className={styles.card}>
                <h3>
                  <Translate id="homepage.logic.card3.title">Artifacts</Translate>
                </h3>
                <p>
                  <Translate id="homepage.logic.card3.text">
                    Practical instruments for applying the framework in decision-making, operation, and change.
                  </Translate>
                </p>
              </div>
            </div>
          </section>
        </div>
      </main>
    </Layout>
  );
}